import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';

class HotDeskSelectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HotDeskSelectionScreenState();
  }
}

class _HotDeskSelectionScreenState extends State {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Choosing Desk"),
        backgroundColor: bordaGreen,
      ),
      body: Center(
        child: Text("Event and Calendar Screen"),
      ),
    );
  }

  







}
