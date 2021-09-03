import 'dart:async';

import 'package:bordatech/httprequests/birthdays/birthdays.dart';
import 'package:bordatech/httprequests/meetingroom/all_emplooyes.dart';
import 'package:bordatech/models/birthday_model.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

import 'event_and_calendar_screen2.dart';

enum allMonths {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december
}

String? _subjectText = '',
    _startTimeText = '',
    _endTimeText = '',
    _dateText = '',
    _timeDetails = '';
Color? _headerColor, _viewHeaderColor, _calendarColor;
Future? getAllBirthdays;

List<Birthdays>? _birthdaysList;
final CalendarController _calendarController = CalendarController();

String _getMonthDate(int month) {
  var enumMonth = allMonths.values[month - 1];
  String monthName = enumMonth.toString().split('.').last;
  return monthName;
}

class BirthdayCalendarScreen2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BirthdayCalendarScreenState2();
  }
}

class _BirthdayCalendarScreenState2 extends State<BirthdayCalendarScreen2> {
  String userId = "";
  String officeId = "";
  String? userToken;
  Future? kullanicilar;
  Future? api;

  Future<void> getBirthdaysForAllEmplooyes() async {
    await getuserInfo();

    setState(() {});

    final String apiUrl = Constants.HTTPURL + "/api/Birthday/getAll";

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

      _birthdaysList =
          body.map((dynamic item) => Birthdays.fromJson(item)).toList();
    } else {
      return null;
    }

    print("STATUS CODE FOR BIRTHDAYS " + response.statusCode.toString());
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

    getAllBirthdays = getBirthdaysForAllEmplooyes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bordaSoftGreen,
      body: FutureBuilder(
        future: getAllBirthdays,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) * 0.8,
              child: getScheduleViewCalendar(
                  context: context, reservations: _getBirthdays()),
            );
          }
        },
      ),
    );
  }
}

SfCalendar getScheduleViewCalendar(
    {required BuildContext context,
    DataSource? reservations,
    dynamic scheduleViewBuilder}) {
  List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.month,
    CalendarView.schedule
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
                height: 80,
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
    view: CalendarView.schedule,
    dataSource: reservations,
    showDatePickerButton: true,
    onTap: calendarTapped,
    /* scheduleViewSettings: ScheduleViewSettings(
      hideEmptyScheduleWeek: true,
    ), */
    scheduleViewMonthHeaderBuilder: (context, scheduleViewBuilder) {
      final String monthName = _getMonthDate(scheduleViewBuilder.date.month);
      return Center(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Image(
              image: AssetImage('assets/' + monthName + '.jpg'),
              fit: BoxFit.fitWidth,
              width: scheduleViewBuilder.bounds.width,
              height: 80,
            ),
            Positioned(
              left: 8,
              right: 0,
              top: 8,
              bottom: 0,
              child: Text(
                monthName.toUpperCase() +
                    ' ' +
                    scheduleViewBuilder.date.year.toString(),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            )
          ],
        ),
      );
    },
  );
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

DataSource _getBirthdays() {
  final List<Appointment> birthdays = <Appointment>[];

  for (int i = 0; i < _birthdaysList!.length; i++) {
    DateTime bDay =
        DateTime.parse(_birthdaysList![i].birthday.toIso8601String());

    String subject = "Today is ${_birthdaysList![i].fullName}'s birthday!";

    // added recurrence appointment
    birthdays.add(Appointment(
        subject: subject,
        startTime: bDay,
        endTime: bDay.add(const Duration(hours: 1)),
        color: colorCollection[random.nextInt(9)],
        isAllDay: true,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=365'));
  }

  return DataSource(birthdays);
}

void _showToast(S) {
  Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
}

void _showEventDetails(BuildContext context, String str) {
  showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.85,
                child: Container(
                    child: InteractiveViewer(
                  maxScale: 100.2,
                  minScale: 0.2,
                  child: Text(
                    str,
                    style: TextStyle(fontSize: 20),
                  ),
                )),
              ),
            ),
          ),
        );
      });
}
