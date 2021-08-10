import 'package:flutter/material.dart';

class EventCalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventCalendarScreenState();
  }
}

class _EventCalendarScreenState extends State {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Borda"),
      ),
      body: Center(
        child: Text("Event and Calendar Screen"),
      ),
    );
  }
}
