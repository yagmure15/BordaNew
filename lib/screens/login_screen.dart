import 'dart:convert';

import 'package:bordatech/httprequests/login/user_login_model.dart';
import 'package:bordatech/screens/register.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bordatech/screens/dashboard_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenScreenState createState() => _LoginScreenScreenState();
}

void _showToast(S) {
  Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
}

class _LoginScreenScreenState extends State<LoginScreen> {
  String _password = "";
  String? fcmToken;
  var isHaveEmail;

  Future<UserLoginModel?> postData(
      String email, String password, String fcmToken) async {
    final String apiUrl = Constants.HTTPURL + "/api/users/login";

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"email": email, "password": password, "FcmToken": fcmToken}));
    print(response.statusCode);
    if (response.statusCode > 199 && response.statusCode < 300) {
      final String results = response.body;
      return userLoginModelFromJson(results);
    } else {

      return null;
    }
  }

  Future<void> postData2(
      String email, String password, String fcmToken) async {
    final String apiUrl = Constants.HTTPURL + "/api/users/login";

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"email": email, "password": password, "FcmToken": fcmToken}));
    print(response.statusCode);
    if (response.statusCode > 199 && response.statusCode < 300) {
      var res = jsonDecode(response.body);

      isHaveEmail = res["email"].toString();

    } else {

    }
  }

  getToken() async {
    this.fcmToken = await FirebaseMessaging.instance.getToken();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserLoginModel? _user;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.png"), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 60.0, horizontal: 30),
                child: Center(
                  child: Container(
                    width: 130,
                    height: 90,
                    child: Image(
                      image: AssetImage("assets/bordaiot.png"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                child: TextField(
                  controller: emailController,
                  style: TextStyle(
                    color: bordaOrange,
                  ),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      //labelText: 'Email',
                      hintText: 'mehmet.nakipoglu@bordatech.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 15, bottom: 40),
                child: TextField(
                  controller: passwordController,
                  style: TextStyle(
                    color: bordaOrange,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    //labelText: 'Password',
                    hintText: 'Enter your password!',
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: bordaOrange,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(bottom: 20),
                child: TextButton(
                  onPressed: () async {
                    String email = emailController.text;
                    String password = passwordController.text;

                    if (email.isEmpty && _password.isEmpty) {
                      _showToast("Email and password cannot be empty!");
                    } else if (email.isEmpty) {
                      _showToast("Email cannot be empty!!");
                    } else if (password.isEmpty) {
                      _showToast("Password cannot be empty!");
                    } else {
                      final UserLoginModel? user =
                          await postData(email, password, fcmToken!);

                      setState(() {
                        _user = user;
                      });

                      if (_user == null) {
                        _showToast("Email amd/or password is not correct!");
                      } else {

                        print("USERSSSS" + _user!.expiration.toString());
                        setUserValues(
                          officeId: _user!.userResource.officeId,
                          ID: _user!.id.toString(),
                          name: _user!.userResource.fullName,
                          email: _user!.userResource.email,
                          token: _user!.token,
                          expiration: _user!.expiration.toString(),
                        );

                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardScreen()));
                      }
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/fish.png"),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showToast(
                              "This feature is currently inactivated. Please contact with your IT Manager!");
                        },
                        child: Text(
                          'Forget Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setUserValues({
    required String ID,
    required String name,
    required String token,
    required String expiration,
    required String email,
    required int officeId,
  }) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("name", name);
    pref.setString("userID", ID);
    pref.setString("token", token);
    pref.setString("expiration", expiration);
    pref.setString("email", email);
    pref.setInt("officeId", officeId);
  }
}
