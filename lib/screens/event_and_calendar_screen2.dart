import 'dart:async';

import 'package:bordatech/httprequests/events/event_model.dart';
import 'package:bordatech/models/user_model.dart';
import 'package:bordatech/screens/birthday_calendar_screen.dart';
import 'package:bordatech/screens/my_calendar_screen.dart';
import 'package:bordatech/screens/office_res_calendar_screen.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

final Random random = Random();
String? _subjectText = '',
    _startTimeText = '',
    _endTimeText = '',
    _dateText = '',
    _timeDetails = '';
Color? _headerColor, _viewHeaderColor, _calendarColor;

final List<Color> colorCollection = <Color>[
  Color(0xFFa31449),
  Color(0xFF24611a),
  Color(0xFFb3a329),
  Color(0xFF541FC7),
  Color(0xFFC71f9D),
  Color(0xFFAA00FF),
  Color(0xFF01A1EF),
  Color(0xFF36B37B),
  Color(0xFFFC571D)
];

final CalendarController _calendarController = CalendarController();
List<EventOrganizationModel>? _eventList;

class EventCalendarScreen2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventCalendarScreenState2();
  }
}

class _EventCalendarScreenState2 extends State<EventCalendarScreen2> {
  String userId = "";
  String officeId = "";
  String? userToken;
  Future? allEvents;

  Future<void> getAllEvents() async {
    await getuserInfo();
    setState(() {});

    final String apiUrl = Constants.HTTPURL + "/getAll";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );
    if (response.statusCode == 200) {
      final String responsString = response.body;
      List<dynamic> body = cnv.jsonDecode(responsString);

      setState(() {
        _eventList = body
            .map((dynamic item) => EventOrganizationModel.fromJson(item))
            .toList();
      });
    } else {
      return null;
    }

    print("STATUS CODE FOR EVENTS " + response.statusCode.toString());
  }

  Future<void> getuserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("userID").toString();
    officeId = pref.getInt("officeId").toString();
    userToken = pref.getString("token").toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _calendarController.view = CalendarView.month;

    allEvents = getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bordaSoftGreen,
      body: FutureBuilder(
        future: allEvents,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          if(snapshot.connectionState != ConnectionState.done){

            return Center(child: CircularProgressIndicator(),);
          }else {
            return Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) * 0.80,
              child: getCalendar(
                  context: context, reservations: _getAppointmentDetails()),
            );
          }


        },
      ),
    );
  }
}

SfCalendar getCalendar(
    {required BuildContext context,
    DataSource? reservations,
    dynamic scheduleViewBuider}) {
  List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.month,
  ];

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.subject;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.startTime)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();
      if (appointmentDetails.isAllDay) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: new Text('$_subjectText')),
              content: Container(
                height: MediaQuery.of(context).size.height/3,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '$_dateText',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(''),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(_timeDetails!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(appointmentDetails.notes.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('close'))
              ],
            );
          });
    }
  }

  return SfCalendar(
    controller: _calendarController,
    allowedViews: _allowedViews,
    monthViewSettings: MonthViewSettings(
      showAgenda: true,
      agendaViewHeight: 200,
      agendaItemHeight: 50,
      appointmentDisplayCount: 10,
      showTrailingAndLeadingDates: false,
      numberOfWeeksInView: 5,
      dayFormat: 'EEE',
    ),
    view: CalendarView.month,
    onTap: calendarTapped,
    dataSource: reservations,
    showDatePickerButton: true,
    timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: Duration(hours: 2),
        timeIntervalHeight: 70.0,
        timeIntervalWidth: 120,
        timeRulerSize: 40),
  );
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

DataSource _getAppointmentDetails() {
  final List<Appointment> events = <Appointment>[];

  for (int i = 0; i < _eventList!.length; i++) {
    DateTime start = DateTime.parse(_eventList![i].startDate.toIso8601String());
    DateTime end = DateTime.parse(_eventList![i].endDate.toIso8601String());
    // added recurrence appointment

    events.add(
      Appointment(
        subject: _sbj(_eventList![i].eventType),
        startTime: start,
        endTime: end,
        color: colorCollection[random.nextInt(9)],
        notes: _eventList![i].organizer.toString(),
      ),
    );
  }
  return DataSource(events);
}

_sbj(int i) {
  if (i == 0) {
    return "Competition";
  } else if (i == 1) {
    return "Meeting";
  } else {
    return "Celebration";
  }
}