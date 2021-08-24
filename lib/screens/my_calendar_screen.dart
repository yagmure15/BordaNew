import 'package:bordatech/models/user_model.dart';
import 'package:bordatech/screens/birthday_calendar_screen.dart';
import 'package:bordatech/screens/event_and_calendar_screen.dart';
import 'package:bordatech/screens/office_res_calendar_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyCalendarScreenState();
  }
}

class _MyCalendarScreenState extends State<MyCalendarScreen> {
  @override
  Widget build(BuildContext context) {
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
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) * 0.8,
              child: getCalendar(reservations: _getMyReservations()),
            ),
          ],
        ),
      ),
    );
  }
}

SfCalendar getCalendar({DataSource? reservations, dynamic scheduleViewBuider}) {
  List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.month,
  ];

  return SfCalendar(
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
  // TODO: Birthday models can change into "2021-08-25T18:30:37.773Z"
  final List<MyReservation> subjectCollection = <MyReservation>[
    MyReservation(
        title: "Notify",
        startDay: "2021-08-20T09:00:37.773Z",
        endDay: "2021-08-20T17:00:37.773Z"),
    MyReservation(
        title: "Meeting Room",
        startDay: "2021-08-20T13:30:37.773Z",
        endDay: "2021-08-20T15:00:37.773Z"),
    MyReservation(
        title: "Hot Desk",
        startDay: "2021-08-23T09:00:37.773Z",
        endDay: "2021-08-23T12:00:37.773Z"),
    MyReservation(
        title: "Hot Desk",
        startDay: "2021-08-27T09:00:37.773Z",
        endDay: "2021-08-27T14:00:37.773Z"),
    MyReservation(
        title: "Meeting Room",
        startDay: "2021-08-26T10:15:37.773Z",
        endDay: "2021-08-26T11:45:37.773Z"),
    MyReservation(
        title: "Hot Desk Room",
        startDay: "2021-08-26T13:15:37.773Z",
        endDay: "2021-08-26T16:45:37.773Z"),
  ];

  final List<Appointment> myReservations = <Appointment>[];
  for (int i = 0; i < subjectCollection.length; i++) {
    DateTime start = DateTime.parse(subjectCollection[i].startDay);
    DateTime end = DateTime.parse(subjectCollection[i].endDay);
    // added recurrence appointment
    myReservations.add(
      Appointment(
        subject: subjectCollection[i].title,
        startTime: start,
        endTime: end,
        color: colorCollection[random.nextInt(9)],
      ),
    );
  }

  return DataSource(myReservations);
}
