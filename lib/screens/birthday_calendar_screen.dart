import 'package:bordatech/models/birthday_model.dart';
import 'package:bordatech/screens/event_and_calendar_screen.dart';
import 'package:bordatech/screens/my_calendar_screen.dart';
import 'package:bordatech/screens/office_res_calendar_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
String _getMonthDate(int month) {
  var enumMonth = allMonths.values[month - 1];
  String monthName = enumMonth.toString().split('.').last;
  return monthName;
}

class BirthdayCalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BirthdayCalendarScreenState();
  }
}

class _BirthdayCalendarScreenState extends State<BirthdayCalendarScreen> {
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
              child: getScheduleViewCalendar(reservations: _getBirthdays()),
            ),
          ],
        ),
      ),
    );
  }
}

SfCalendar getScheduleViewCalendar(
    {DataSource? reservations, dynamic scheduleViewBuilder}) {
  List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.month,
    CalendarView.schedule
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
    view: CalendarView.schedule,
    dataSource: reservations,
    showDatePickerButton: true,
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
