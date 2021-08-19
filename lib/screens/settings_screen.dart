import 'package:bordatech/screens/login_screen.dart';
import 'package:bordatech/screens/update_password_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        title: Image.asset(
          "assets/borda.png",
          fit: BoxFit.contain,
          height: 30,
        ),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
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
            Container(
              width: 320,
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
                  'Mehmet Baran Nakipoğlu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: 320,
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
                  'mehmet.nakipoglu@bordatech.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: 320,
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
              width: 320,
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
            Container(
              width: 320,
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
                child: Text(
                  'Light Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: 320,
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
              width: 320,
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
}
