import 'dart:math';

import 'package:bordatech/models/birthday_model.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventCalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventCalendarScreenState();
  }
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  String _selectedCalendarType = "Aylık";
  List<CalendarView> calanderView = [
    CalendarView.month,
    CalendarView.week,
    CalendarView.day
  ];
  late _DataSource events;
  String? ayAdi;
  @override
  void initState() {
    events = _DataSource(_getAppointments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bordaSoftGreen,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')),
        title: Text('Birthdays'),
        backgroundColor: bordaGreen,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(onSelected: (Selected) {
            setState(() {
              _selectedCalendarType = Selected;
              _showToast(_selectedCalendarType);
            });
          }, itemBuilder: (context) {
            return {'Events', 'Meeting Rooms', "My Calendar"}
                .map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          })
        ],
      ),
      body: getScheduleViewCalendar(
        events: events,
      ),
    );
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  SfCalendar getScheduleViewCalendar(
      {_DataSource? events, dynamic scheduleViewBuilder}) {
    return SfCalendar(
      showDatePickerButton: true,
      scheduleViewMonthHeaderBuilder: (context, scheduleViewBuilder) {
        final String monthName = _getMonthDate(scheduleViewBuilder.date.month);
        return Stack(
          children: [
            Image(
                image: ExactAssetImage('assets/' + monthName + '.jpg'),
                fit: BoxFit.fitWidth,
                width: scheduleViewBuilder.bounds.width,
                height: scheduleViewBuilder.bounds.height),
            Positioned(
              left: 20,
              right: 0,
              top: 20,
              bottom: 0,
              child: Text(
                monthName.toUpperCase() +
                    ' ' +
                    scheduleViewBuilder.date.year.toString(),
                style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w900),
              ),
            )
          ],
        );
      },
      view: CalendarView.schedule,
      dataSource: events,
    );
  }

  List<Appointment> _getAppointments() {
    final List<BirthdayModel> subjectCollection = <BirthdayModel>[
      BirthdayModel(name: "Baran", day: 19, month: 8, year: 1995),
      BirthdayModel(name: "Eymen", day: 20, month: 8, year: 1995),
      BirthdayModel(name: "Ifrah", day: 20, month: 8, year: 1995),
      BirthdayModel(name: "Yusuf", day: 24, month: 8, year: 1995),
      BirthdayModel(name: "Zeynep", day: 25, month: 8, year: 1995),
      BirthdayModel(name: "Hatice", day: 20, month: 8, year: 1995),
      BirthdayModel(name: "Burçin", day: 27, month: 8, year: 1995),
      BirthdayModel(name: "Barış", day: 29, month: 8, year: 1995),
      BirthdayModel(name: "Utku", day: 29, month: 8, year: 1995),
      BirthdayModel(name: "Eda", day: 30, month: 8, year: 1995),
      BirthdayModel(name: "Baran", day: 19, month: 8, year: 1995),
      BirthdayModel(name: "Ali", day: 20, month: 9, year: 1996),
      BirthdayModel(name: "Veli", day: 19, month: 10, year: 1997),
      BirthdayModel(name: "Ahmet", day: 7, month: 1, year: 1998),
      BirthdayModel(name: "Mehmet", day: 18, month: 5, year: 1999),
      BirthdayModel(name: "Zengin", day: 27, month: 12, year: 2000),
      BirthdayModel(name: "Engin", day: 13, month: 11, year: 2001)
    ];

    final List<Color> colorCollection = <Color>[];
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF0A8043));

    final Random random = Random();
    final List<Appointment> appointments = <Appointment>[];

    for (int i = 0; i < subjectCollection.length; i++) {
      DateTime date = DateTime.now();
      int year = DateTime.now().year;
      date = DateTime(subjectCollection[i].year, subjectCollection[i].month,
          subjectCollection[i].day, 11, 0, 0);
      // added recurrence appointment
      appointments.add(Appointment(
          subject: subjectCollection[i].name +
              " ${year - subjectCollection[i].year} Yaşında!!!",
          startTime: date,
          endTime: date.add(const Duration(hours: 1)),
          color: colorCollection[random.nextInt(9)],
          isAllDay: true,
          recurrenceRule: 'FREQ=DAILY;INTERVAL=365'));
    }

    return appointments;
  }

  String _getMonthDate(int month) {
    switch (month) {
      case 1:
        ayAdi = "january";
        break;
      case 2:
        ayAdi = "february";
        break;
      case 3:
        ayAdi = "march";
        break;
      case 4:
        ayAdi = "april";
        break;
      case 5:
        ayAdi = "may";
        break;
      case 6:
        ayAdi = "june";
        break;
      case 7:
        ayAdi = "july";
        break;
      case 8:
        ayAdi = "august";
        break;
      case 9:
        ayAdi = "september";
        break;
      case 10:
        ayAdi = "october";
        break;
      case 11:
        ayAdi = "november";
        break;
      case 12:
        ayAdi = "december";
        break;
    }

    return ayAdi.toString();
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
