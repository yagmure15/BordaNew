import 'package:bordatech/models/event_model.dart';
import 'package:bordatech/models/user_model.dart';
import 'package:bordatech/screens/birthday_calendar_screen.dart';
import 'package:bordatech/screens/my_calendar_screen.dart';
import 'package:bordatech/screens/office_res_calendar_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';

final Random random = Random();

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

class EventCalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventCalendarScreenState();
  }
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
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
              child: getCalendar(reservations: _getEvents()),
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

DataSource _getEvents() {
  final List<EventModel> subjectCollection = <EventModel>[
    EventModel(
        eventType: "Competition \u{1F3C6}",
        startDay: "2021-08-24T18:30:37.773Z",
        endDay: "2021-08-24T20:30:37.773Z",
        note: "join the frisbee! May be the best team win! \{1F3C6}"),
    EventModel(
        eventType: "Celebration \u{1F37A}",
        startDay: "2021-08-29T18:30:37.773Z",
        endDay: "2021-08-29T20:30:37.773Z",
        note: "Let's celebrate the Milestone! \{u1F451 }"),
    EventModel(
        eventType: "Meeting \u{1F37A}",
        startDay: "2021-08-20T14:30:37.773Z",
        endDay: "2021-08-20T15:45:37.773Z",
        note: "Coffee Time \u{1F37A}"),
    EventModel(
        eventType: "Competition \u{1F3C6}",
        startDay: "2021-08-28T10:30:37.773Z",
        endDay: "2021-08-28T13:30:37.773Z",
        note: "join the frisbee! May be the best team win! \{u1F451 }"),
  ];

  final List<Appointment> events = <Appointment>[];

  for (int i = 0; i < subjectCollection.length; i++) {
    DateTime start = DateTime.parse(subjectCollection[i].startDay);
    DateTime end = DateTime.parse(subjectCollection[i].endDay);
    // added recurrence appointment
    events.add(
      Appointment(
        subject: subjectCollection[i].eventType,
        startTime: start,
        endTime: end,
        color: colorCollection[random.nextInt(9)],
        notes: subjectCollection[i].note,
      ),
    );
  }
  return DataSource(events);
}
