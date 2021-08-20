import 'package:bordatech/models/birthday_model.dart';
import 'package:bordatech/models/event_model.dart';
import 'package:bordatech/models/user_model.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';

final Random random = Random();

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
final List<Color> colorCollection = <Color>[
  Color(0xFFF8BBD0),
  Color(0xFFE57373),
  Color(0xFFE6EE9C),
  Color(0xFF90DEEA),
  Color(0xFFBA68C8),
  Color(0xFFAA00FF),
  Color(0xFF01A1EF),
  Color(0xFF36B37B),
  Color(0xFFFC571D)
];

String _getMonthDate(int month) {
  var enumMonth = allMonths.values[month - 1];
  String monthName = enumMonth.toString().split('.').last;
  return monthName;
}

class EventCalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventCalendarScreenState();
  }
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  late DataSource events;
  bool isEvent = false;
  bool isBirthday = false;
  bool isMyCalendar = true;
  bool isGeneral = false;
  CalendarView viewType = CalendarView.schedule;
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
        title: Text('Events and Calendar'),
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
                      setState(
                        () {
                          isEvent = true;
                          isBirthday = false;
                          isMyCalendar = false;
                          isGeneral = false;
                          viewType = CalendarView.schedule;
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          "Events",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isEvent ? bordaOrange : Colors.white30),
                        ),
                        if (isEvent)
                          Container(
                            margin: EdgeInsets.only(top: 1),
                            height: 2,
                            width: 30,
                            color: Colors.orange,
                          )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEvent = false;
                        isBirthday = true;
                        isMyCalendar = false;
                        isGeneral = false;
                        viewType = CalendarView.schedule;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Birthdays",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isBirthday ? bordaOrange : Colors.white30),
                        ),
                        if (isBirthday)
                          Container(
                            margin: EdgeInsets.only(top: 1),
                            height: 2,
                            width: 30,
                            color: Colors.orange,
                          )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          isEvent = false;
                          isBirthday = false;
                          isMyCalendar = true;
                          isGeneral = false;
                          viewType = CalendarView.week;
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          "My Calendar",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color:
                                  isMyCalendar ? bordaOrange : Colors.white30),
                        ),
                        if (isMyCalendar)
                          Container(
                            margin: EdgeInsets.only(top: 1),
                            height: 2,
                            width: 30,
                            color: Colors.orange,
                          )
                      ],
                    ),
                  ),
                  /* GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          isEvent = false;
                          isBirthday = false;
                          isMyCalendar = false;
                          isGeneral = true;
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          "General Office",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isGeneral ? bordaOrange : Colors.white30),
                        ),
                        if (isGeneral)
                          Container(
                            margin: EdgeInsets.only(top: 1),
                            height: 2,
                            width: 30,
                            color: Colors.orange,
                          )
                      ],
                    ),
                  ), */
                ],
              ),
            ),
            if (isEvent)
              Container(
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height) * 0.8,
                  child: getScheduleViewCalendar(
                      events: _getEvents(), calType: viewType)),
            if (isBirthday)
              Container(
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height) * 0.8,
                  child: getScheduleViewCalendar(
                      events: _getBirthdays(), calType: viewType)),
            // TODO: Have a global variable to set the calendar view type
            if (isMyCalendar)
              Container(
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height) * 0.8,
                  child: getScheduleViewCalendar(
                      events: _getMyReservations(), calType: viewType)),
          ],
        ),
      ),
    );
  }
}

SfCalendar getScheduleViewCalendar(
    {DataSource? events,
    dynamic scheduleViewBuilder,
    required CalendarView calType}) {
  return SfCalendar(
    view: calType,
    dataSource: events,
    showDatePickerButton: true,
    timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: Duration(hours: 2),
        timeIntervalHeight: 70.0,
        timeIntervalWidth: 120,
        timeRulerSize: 40),
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
  // TODO: Birthday models can change into "2021-08-25T18:30:37.773Z"
  final List<BirthdayModel> subjectCollection = <BirthdayModel>[
    BirthdayModel(name: "Mehmet", birthday: "1998-08-29T18:30:37.773Z"),
    BirthdayModel(name: "Eymen", birthday: "1998-08-26T18:30:37.773Z"),
    BirthdayModel(name: "Engin", birthday: "1998-08-26T18:30:37.773Z"),
    BirthdayModel(name: "Ifrah", birthday: "1996-08-28T18:30:37.773Z"),
    BirthdayModel(name: "Yusuf", birthday: "1997-09-01T18:30:37.773Z"),
    BirthdayModel(name: "Zeynep", birthday: "1997-09-02T18:30:37.773Z"),
  ];

  final List<Appointment> birthdays = <Appointment>[];

  for (int i = 0; i < subjectCollection.length; i++) {
    DateTime bDay = DateTime.parse(subjectCollection[i].birthday);

    String yearsOld = " is " +
        (DateTime.now().year - bDay.year.toInt()).toString() +
        " years old. Happy Birthday!";

    // added recurrence appointment
    birthdays.add(Appointment(
        subject: subjectCollection[i].name + yearsOld,
        startTime: bDay,
        endTime: bDay.add(const Duration(hours: 1)),
        color: colorCollection[random.nextInt(9)],
        isAllDay: true,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=365'));
  }

  return DataSource(birthdays);
}

DataSource _getEvents() {
  final List<EventModel> subjectCollection = <EventModel>[
    EventModel(
        eventType: "Competition \u{1F3C6}",
        startDay: "2021-08-25T18:30:37.773Z",
        endDay: "2021-08-25T20:30:37.773Z",
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
        startDay: "2021-08-20T09:00:37.773Z",
        endDay: "2021-08-20T14:00:37.773Z"),
    MyReservation(
        title: "Meeting Room",
        startDay: "2021-08-20T10:15:37.773Z",
        endDay: "2021-08-20T11:45:37.773Z"),
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
