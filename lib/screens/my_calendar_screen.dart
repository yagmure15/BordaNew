import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bordatech/httprequests/mycalendar/my_calendar_model.dart';
import 'package:bordatech/models/user_model.dart';
import 'package:bordatech/screens/birthday_calendar_screen.dart';
import 'package:bordatech/screens/event_and_calendar_screen.dart';
import 'package:bordatech/screens/office_res_calendar_screen.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;




Future<void> removeBySelectedId(String str) async {

  final String apiUrl = Constants.HTTPURL + str;

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $userToken",
    },
  );

  if (response.statusCode == 204) {

    print(str + "SİLİNDİ");

  } else {

  }


}


String? _subjectText = '',
    _startTimeText = '',
    _endTimeText = '',
    _dateText = '',
    _timeDetails = '';
Color? _headerColor, _viewHeaderColor, _calendarColor;

MyCalendarModel? _myCalendar;
final CalendarController _calendarController = CalendarController();
String userId = "";
String officeId = "";
String? userToken;
Future? takvim;
Future? getAllRes;

class MyCalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyCalendarScreenState();
  }
}

class _MyCalendarScreenState extends State<MyCalendarScreen> {



  Future<void> getMyAllReservations() async {
    await getuserInfo();
    setState(() { });


    final String apiUrl = Constants.HTTPURL + "/api/users/$userId/reservations";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    if (response.statusCode == 200) {


      setState(() {
        _myCalendar = myCalendarModelFromJson(response.body);
      });


      print(_myCalendar!.hotDeskReservations[5].id.toString());



    } else {

    }

    print("STATUS CODE FOR MY CALENDAR SCREEN " + response.statusCode.toString());

  }
  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }
  Future <void> getuserInfo() async {
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

    Timer(Duration(milliseconds: 500), () {


    });

getAllRes = getMyAllReservations();



  }





  @override
  Widget build(BuildContext context) {
    _showToast("$userId");
    return Scaffold(
      backgroundColor: bordaSoftGreen,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')),
        title: Text('Calendars'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 70,
                ),
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventCalendarScreen()));
                      },
                      child: Column(
                        children: [
                          Text(
                            "Events",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white30),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BirthdayCalendarScreen()));
                      },
                      child: Column(
                        children: [
                          Text(
                            "Birthdays",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white30),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCalendarScreen()));
                      },
                      child: Column(
                        children: [
                          Text(
                            "My Calendar",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: bordaOrange),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 1),
                            height: 2,
                            width: 45,
                            color: Colors.orange[800],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OfficeCalendarScreen()));
                      },
                      child: Column(
                        children: [
                          Text(
                            "Office Calendar",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white30),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: getAllRes,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                    return Container(
                      padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: (MediaQuery.of(context).size.height) * 0.8,
                      child: getCalendar(context: context, reservations: _getMyReservations()),
                    );


                },
              ),
            ],
          ),
        ),
      ),
    );
  }
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
              title: Container(child: new Text(appointmentDetails.subject)),
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
                     // Navigator.of(context).pop();

                      String str ="";
                      ;
                      if(_subjectText == "Hotdesk Reservation"){


                        str = "/api/hotdesks/reservations/${appointmentDetails.id}/cancel";
                      }
                      removeBySelectedId(str);
                      Navigator.pop(context);
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCalendarScreen()));



                    },
                    child: new Text('REMOVE'))
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
    dataSource: reservations,
    onTap: calendarTapped,
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

DataSource _getMyReservations() {

  final List<Appointment> myReservations = <Appointment>[];
  for (int i = 0; i < _myCalendar!.hotDeskReservations.length; i++) {
    DateTime start = DateTime.parse(_myCalendar!.hotDeskReservations[i].startDate.toString());
    DateTime end = DateTime.parse(_myCalendar!.hotDeskReservations[i].startDate.toString());
    // added recurrence appointment
      print("hotdesk sayısı : $i "+_myCalendar!.hotDeskReservations[i].isCancelled.toString());
    if(_myCalendar!.hotDeskReservations[i].isCancelled == false){

      myReservations.add(
        Appointment(
          id: _myCalendar!.hotDeskReservations[i].id.toString(),

          subject: "Hotdesk Reservation",
          startTime: start,
          endTime: end,
          color: colorCollection[random.nextInt(9)],
        ),
      );
    }


  }
  for (int i = 0; i < _myCalendar!.meetingRoomReservations.length; i++) {
    DateTime start = DateTime.parse(_myCalendar!.meetingRoomReservations[i].startDate.toString());
    DateTime end = DateTime.parse(_myCalendar!.meetingRoomReservations[i].startDate.toString());
    // added recurrence appointment

    if(_myCalendar!.meetingRoomReservations[i] == false){
      myReservations.add(
        Appointment(
          id: _myCalendar!.meetingRoomReservations[i].id.toString(),
          subject: "Meeting Room Reservation",
          startTime: start,
          endTime: end,
          color: colorCollection[random.nextInt(9)],
        ),
      );
    }

  }
  for (int i = 0; i < _myCalendar!.notificationOfArrivals.length; i++) {
    DateTime start = DateTime.parse(_myCalendar!.notificationOfArrivals[i].dateOfArrival.toString());
    DateTime end = DateTime.parse(_myCalendar!.notificationOfArrivals[i].dateOfArrival.toString());
    // added recurrence appointment
    if(_myCalendar!.notificationOfArrivals[i].isCancelled == false){
      myReservations.add(
        Appointment(
          id: _myCalendar!.notificationOfArrivals[i].id.toString(),
          subject: "Notification of Arrivals",
          startTime: start,
          endTime: end,
          color: colorCollection[random.nextInt(9)],
        ),
      );
    }

  }





  return DataSource(myReservations);
}
