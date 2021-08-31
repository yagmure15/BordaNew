import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bordatech/provider/theme_notifier.dart';
import 'package:bordatech/screens/dashboard_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bordatech/screens/terms_privacy_screen.dart';
import 'package:bordatech/screens/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

String finalEmail = "null";

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_important_channel", "High Important Channel", "description",
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /* final SharedPreferences prefs = await SharedPreferences.getInstance();
  @override
  var x = (prefs.getBool('isLoggedIn') == null)
      ? false
      : prefs.getBool('isLoggedIn');
  isLoggedin = x; */
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeColorData>(
      create: (BuildContext context) => ThemeColorData(),
      builder: (context, _) {
        Provider.of<ThemeColorData>(context).loadThemeFromSharedPref();
        return MaterialApp(
          theme: Provider.of<ThemeColorData>(context).themeColor,
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
            splash: Image.asset("assets/bordaiot.png"),
            nextScreen: Splash(),
            splashTransition: SplashTransition.rotationTransition,
            backgroundColor: bordaSoftGreen,
            duration: 800,
            animationDuration: Duration(milliseconds: 1500),
          ),
        );
      },
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  @override
  void initState() {
    super.initState();
    getuserInfo();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.green,
                    playSound: true,
                    icon: "@mipmap/ic_launcher")));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(notification.body.toString()),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  void getuserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      finalEmail = pref.getString("email").toString();
    });
    print(finalEmail);
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "title",
        "body",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.green,
                playSound: true,
                icon: "@mipmap/ic_launcher")));
  }

  Future<void> _handleStartScreen() async {
    if (finalEmail == "null") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    //String userId = prefs.getString("userID").toString();
    //bool isLoggedin = (userId == "userID") ? false : true;
    //print(isLoggedin);
    // isLoggedin = true;

    if (_seen) {
      _handleStartScreen();
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) =>
      Timer(Duration(milliseconds: 300), checkFirstSeen);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        /* child: Text(
          "Loading...",
          style: TextStyle(
            fontSize: 24,
            color: bordaOrange,
          ),
        ), */
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bordaGreen,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  right: 30, left: 30, bottom: 40, top: 60),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
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
                  /* margin:
                      EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40), */
                  width: MediaQuery.of(context).size.width - 80,
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
                bottom: 40,
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
                          Navigator.pop(context);
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
