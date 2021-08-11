import 'package:bordatech/utils/hex_color.dart';
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
      backgroundColor: bordaSoftGreen,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')),
        title: Image.asset(
          "assets/borda.png",
          fit: BoxFit.contain,
          height: 30,
        ),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Center(),
    );
  }
}
