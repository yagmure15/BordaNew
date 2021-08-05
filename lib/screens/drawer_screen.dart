import 'package:bordatech/screens/event_and_calendar_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Color(HexColor.toHexCode("#2a4449")),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 20),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://images6.alphacoders.com/337/337780.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  Text(
                    "Engin Yağmur",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ), Text(
                    "engin.yagmur@bordatech.com",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today ),
            title: Text("Events and Calendar"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventCalendarScreen()));

            },
          ),  ListTile(
            leading: Icon(Icons.wb_sunny_outlined ),
            title: Text("Weather"),
            onTap: null,
          ),  ListTile(
            leading: Icon(Icons.food_bank_outlined ),
            title: Text("Baklava"),
            onTap: null,
          ),  ListTile(
            leading: Icon(Icons.settings ),
            title: Text("Settings"),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
