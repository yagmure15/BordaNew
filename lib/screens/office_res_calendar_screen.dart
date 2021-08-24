import 'package:bordatech/screens/birthday_calendar_screen.dart';
import 'package:bordatech/screens/event_and_calendar_screen.dart';
import 'package:bordatech/screens/my_calendar_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OfficeCalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfficeCalendarScreenState();
  }
}

class _OfficeCalendarScreenState extends State<OfficeCalendarScreen> {
  List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineMonth
  ];
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
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) * 0.8,
              child: SfCalendar(
                allowedViews: _allowedViews,
                resourceViewSettings: ResourceViewSettings(size: 80),
                showDatePickerButton: true,
                view: CalendarView.timelineDay,
                dataSource: _getCalendarDataSource(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

DataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  List<CalendarResource> resources = <CalendarResource>[];
/*   DateTime start = DateTime.parse("2021-08-26T13:15:37.773Z");
  DateTime end = DateTime.parse("2021-08-26T13:15:37.773Z"); */
  List<String> _nameCollection = <String>[];
  _nameCollection.add("Ifrah");
  _nameCollection.add("Baran");
  _nameCollection.add("Engin");
  _nameCollection.add("Eymen");
  _nameCollection.add("Yusuf");
  _nameCollection.add("Eda");
  _nameCollection.add("Burçin");
  _nameCollection.add("Yaren");
  _nameCollection.add("Emine");
  _nameCollection.add("Ata");
  _nameCollection.add("Berkay");
  _nameCollection.add("Zeynep");

  List<String> _subjectCollection = <String>[];
  _subjectCollection.add('Hot Desk');
  _subjectCollection.add('Meeting Room');
  _subjectCollection.add("Will be in the Office!");

  for (int i = 0; i < _nameCollection.length; i++) {
    resources.add(
      CalendarResource(
        displayName: _nameCollection[i],
        id: '000' + i.toString(),
        color: colorCollection[random.nextInt(9)],
        image: ExactAssetImage('assets/user.png'),
      ),
    );
  }
  for (int i = 0; i < resources.length; i++) {
    appointments.add(
      Appointment(
          startTime: DateTime.now().add(Duration(hours: i + 1)),
          endTime: DateTime.now().add(Duration(hours: i)),
          subject: _subjectCollection[random.nextInt(3)],
          color: colorCollection[random.nextInt(9)],
          resourceIds: <Object>['000' + i.toString()]),
    );
  }
  appointments.add(
    Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 2)),
        subject: 'Hot Desk',
        color: colorCollection[random.nextInt(9)],
        resourceIds: <Object>['0001']),
  );
  // For multiple addition https://github.com/SyncfusionExamples/resource-in-flutter-event-calendar/blob/main/lib/main.dart

  return DataSource(appointments, resources);
}
