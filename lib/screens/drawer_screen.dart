import 'package:bordatech/main.dart';

import 'package:bordatech/screens/settings_screen.dart';
import 'package:bordatech/screens/tabbarcalendar.dart';
import 'package:bordatech/screens/weather_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:bordatech/utils/user_info.dart';
import 'package:bordatech/utils/user_simple_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' show launch;

import 'meeting_search_employee.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String fullName = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getuserName();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        fullName,
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
                    "Calendars",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    // TODO: why did you add both the pop and push?
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabBarLayoutCalendar()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.wb_sunny_outlined),
                  title: Text(
                    "Weather & Forecast",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherScreen(),
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: Icon(Icons.food_bank_outlined),
                    title: RichText(
                      text: new TextSpan(
                        text: 'Baklava',
                        style: new TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://www.yemeksepeti.com/gaziantepli-baklavaci-samet-usta-kagithane-sultan-selim-sanayi-mah-istanbul');
                          },
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
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
      ),
    );
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  void getuserName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    fullName = pref.getString("name").toString();
    email = pref.getString("email").toString();
    setState(() {});
  }
}
_showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "\u{1F389}  " + msg,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    ),
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      disabledTextColor: Colors.deepPurple,
      onPressed: () {},
    ),
    backgroundColor: Color(HexColor.toHexCode("#ff5a00")),
  ));
}

