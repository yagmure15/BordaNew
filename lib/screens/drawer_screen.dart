import 'package:bordatech/screens/event_and_calendar_screen.dart';
import 'package:bordatech/screens/settings_screen.dart';
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
            padding: EdgeInsets.all(40),
            color: bordaGreen,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 20),
                    width: 120,
                    height: 110,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://images6.alphacoders.com/337/337780.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  // TODO: should we keep both the name and email in there? What about settings? Don't include email?
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "Engin Yağmur",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                  "Events and Calendar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  // TODO: why did you add both the pop and push?
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventCalendarScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.wb_sunny_outlined),
                title: Text(
                  "Weather",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                onTap: null,
              ),
              ListTile(
                leading: Icon(Icons.food_bank_outlined),
                title: Text(
                  "Baklava",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                onTap: null,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  "Settings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
