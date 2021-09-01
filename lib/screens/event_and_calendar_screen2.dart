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
import 'package:google_fonts/google_fonts.dart';
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
String userId = "";
String officeId = "";
String? userToken;
Future? allEvents;
final CalendarController _calendarController = CalendarController();
List<EventOrganizationModel>? _eventList;

class EventCalendarScreen2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventCalendarScreenState2();
  }
}

class _EventCalendarScreenState2 extends State<EventCalendarScreen2> {


  Future<void> removeBySelectedId(String eventId) async {
    final String apiUrl =
        Constants.HTTPURL + "/api/Events/CancelEvent/" + eventId;

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );
    print("STATUS CODE FOR DELEVE EVENT " + response.statusCode.toString());
    if (response.statusCode == 200) {
      await getAllEvents();
    } else {}
  }

  Future<void> getAllEvents() async {
    await getuserInfo();
    setState(() {});

    final String apiUrl = Constants.HTTPURL + "api/Events/getAll";

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
    getuserInfo();
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
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
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
  SfCalendar getCalendar({required BuildContext context, DataSource? reservations, dynamic scheduleViewBuider}) {
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
        _startTimeText = DateFormat('hh:mm a')
            .format(appointmentDetails.startTime)
            .toString();
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
              return Center(
                child: Material(
                  type: MaterialType.transparency,

                  child: SingleChildScrollView(

                    child:  Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height*0.6,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                height: 120,
                                color: Colors.black12,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage("assets/3drocket.png"),
                                        height: 80,
                                        width: 80,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        _subjectText.toString(),
                                        style: GoogleFonts.indieFlower(fontSize: 22),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 10,),
                                      Text( _dateText.toString() + " \n"+
                                        _timeDetails.toString(),
                                        style: GoogleFonts.indieFlower(fontSize: 16, fontWeight: FontWeight.w800),
                                      ),
                                      Divider(color: Colors.black26,),
                                      Align(

                                        alignment:  Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 20),
                                          child: Text( appointmentDetails.notes.toString(),
                                            style: GoogleFonts.indieFlower(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child:   Container(
                                    margin: EdgeInsets.only(top: 20, right: 20,bottom: 20),
                                    child: FloatingActionButton(
                                      backgroundColor: bordaOrange,
                                      child: Icon(Icons.delete),
                                      onPressed: () async {
                                        removeBySelectedId(appointmentDetails.id.toString());
                                        Navigator.pop(context);


                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),



                  ),
                ),
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
  DataSource _getAppointmentDetails() {
    final List<Appointment> events = <Appointment>[];

    for (int i = 0; i < _eventList!.length; i++) {
      DateTime start =
          DateTime.parse(_eventList![i].startDate.toIso8601String());
      DateTime end = DateTime.parse(_eventList![i].endDate.toIso8601String());
      // added recurrence appointment
      if (_eventList![i].isCancelled == false) {
        events.add(
          Appointment(

            id: _eventList![i].id.toString(),
            subject: _sbj(_eventList![i].eventType),
            startTime: start,
            endTime: end,
            color: colorCollection[random.nextInt(9)],
            notes: _eventList![i].organizer.toString() +" : " +_eventList![i].description.toString(),
          ),
        );
      }
    }
    return DataSource(events);
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
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
