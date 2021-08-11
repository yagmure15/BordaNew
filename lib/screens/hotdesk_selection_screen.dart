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
      backgroundColor: bordaSoftGreen,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')),
        title: Text('Hot Desk Selection'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Center(
        child: Text("Hot Desk Selection Screen"),
      ),
    );
  }
}
