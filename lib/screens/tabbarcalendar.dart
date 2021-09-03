


import 'package:bordatech/httprequests/events/sf_calendar_example.dart';
import 'package:bordatech/screens/dashboard_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';

import 'birthday_calendar_screen2.dart';
import 'event_and_calendar_screen2.dart';
import 'my_calendar_screen2.dart';
import 'office_res_calendar_screen2.dart';

class TabBarLayoutCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TabBarLayoutCalendarState();
  }
}

class _TabBarLayoutCalendarState extends State<TabBarLayoutCalendar> with SingleTickerProviderStateMixin {
  TabController? _tabController ;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')),
        title: Text('Calendars'),
        backgroundColor: bordaGreen,
        centerTitle: true,
        bottom: TabBar(

          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.event_available,), text: "Events",),
            Tab(icon: Icon(Icons.card_giftcard,), text: "Birthdays",),
            Tab(icon: Icon(Icons.person,), text: "Calendar",),
            Tab(icon: Icon(Icons.calendar_today_outlined,), text: "Office",),
          ],


        ),
      ),


      body: TabBarView(
        controller: _tabController,
        children: [
          EventCalendarScreen2(),
          BirthdayCalendarScreen2(),
          MyCalendarScreen2(),
          OfficeCalendarScreen2(),
        ],
      ),
    );
  }
}