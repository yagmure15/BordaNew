import 'package:bordatech/screens/deneme.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bordatech/screens/terms_privacy_screen.dart';
import 'package:bordatech/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*  
      theme: ThemeData(
        textTheme: GoogleFonts.josephinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        
      ),
      */
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bordaGreen,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Center(
                child: Container(
                  width: 140,
                  height: 100,
                  child: Image(
                    image: AssetImage("assets/bordaiot.png"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Container(
                child: Text(
                  'Welcome to Borda Smart App',
                  style: TextStyle(
                    color: bordaOrange,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                child: Text(
                  'Smart Coworking Space App will increase the efficieny of work done by employees, satisfaction of employees/employers and increase the wellness of all!',
                  style: TextStyle(
                    color: bordaOrange,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 80, right: 80, top: 30, bottom: 0),
              child: ElevatedButton(
                child: Container(
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: bordaOrange,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: bordaOrange,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 90,
                right: 90,
                top: 30,
                bottom: 0,
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: bordaOrange,
                    fontSize: 16.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'By clicking Continue, you agree to our ',
                    ),
                    TextSpan(
                      text: 'Terms of Service & Privacy Policy.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsPrivacyPolicy(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
