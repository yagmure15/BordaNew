import 'dart:math';

import 'package:bordatech/provider/theme_notifier.dart';
import 'package:bordatech/screens/login_screen.dart';
import 'package:bordatech/screens/update_password_screen.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:bordatech/utils/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_settings/system_settings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}



class _SettingsScreenState extends State<SettingsScreen> {


  bool isDarkMode = true;
  String fullName = "";
  String email = "";


  @override
  void initState() {
    super.initState();

    getUserNameAndEmail();



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
        title: Image.asset(
          "assets/borda.png",
          fit: BoxFit.contain,
          height: 30,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                child: Center(
                  child: Container(
                    width: 130,
                    height: 90,
                    child: Image(
                      image: AssetImage("assets/account.png"),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              padding: EdgeInsets.symmetric(
                vertical: 4,
              ),
              margin: EdgeInsets.only(bottom: 10),
              //width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: bordaGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              //padding: const EdgeInsets.only(bottom: 5),
              child: Center(
                child: Text(
                  fullName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              padding: EdgeInsets.symmetric(
                vertical: 4,
              ),
              margin: EdgeInsets.only(bottom: 10),
              //width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: bordaGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              //padding: const EdgeInsets.only(bottom: 5),
              child: Center(
                child: Text(
                  email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 95,

              //width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: bordaGreen,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  //fit: BoxFit.fill,
                  image: AssetImage("assets/piggybank.png"),
                  alignment: Alignment(-0.6, -0.4),
                ),
              ),
              //padding: const EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.only(
                top: 30,
                left: 80,
              ),
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                'Borda Coin: 45',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              padding: EdgeInsets.symmetric(
                vertical: 4,
              ),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: bordaGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: (){
                    SystemSettings.app();
                  },
                  child: Text(
                    'Allow Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              padding: EdgeInsets.symmetric(
                vertical: 4,
              ),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: bordaGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      Text(
                        'Light Mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 10,),
                        Switch(
                            value:  Provider.of<ThemeColorData>(context,listen: false).isDark,
                            onChanged: (_){
                              Provider.of<ThemeColorData>(context,listen: false).toggleTheme();
                            }
                        )





                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              padding: EdgeInsets.symmetric(
                vertical: 4,
              ),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: bordaGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePasswordScreen()));
                },
                child: Center(
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              padding: EdgeInsets.symmetric(
                vertical: 4,
              ),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: bordaGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                child: Center(
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void getUserNameAndEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    fullName = pref.getString("name").toString();
    email = pref.getString("email").toString();
    setState(() {});
  }
}




