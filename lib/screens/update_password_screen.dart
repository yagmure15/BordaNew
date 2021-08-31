import 'dart:convert';

import 'package:bordatech/screens/login_screen.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

String? userID, url, userToken;

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  TextEditingController newPasswordController1 = TextEditingController();
  TextEditingController newPasswordController2 = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> postData(String newPassword, String oldPassword) async {
    setState(() {
      url = Constants.HTTPURL + "/api/User/UpdatePassword/" + userID!;
    });

    final response = await http.post(Uri.parse(url!),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode(
            {"newPassword": newPassword, "oldPassword": oldPassword}));

    if (response.statusCode == 200) {
      _showToast("Your password has been successfully changed");
      Navigator.pop(context);
    } else {
      _showToast("You entered incorrectly");
    }
  }

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
        title: Text("Change Password"),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: _passwordTextArea(),
      ),
    );
  }

  Widget _passwordTextArea() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Old Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          TextField(
            controller: oldPasswordController,
            style: TextStyle(
              color: bordaOrange,
            ),
            obscureText: true,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              //labelText: 'Password',
              hintText: 'Enter your password!',
            ),
          ),
          SizedBox(
            height: 26,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "New Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          TextField(
            controller: newPasswordController1,
            style: TextStyle(
              color: bordaOrange,
            ),
            obscureText: true,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              //labelText: 'Password',
              hintText: 'Enter your new password!',
            ),
          ),
          SizedBox(
            height: 13,
          ),
          TextField(
            controller: newPasswordController2,
            style: TextStyle(
              color: bordaOrange,
            ),
            obscureText: true,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              //labelText: 'Password',
              hintText: 'Enter your new password again!',
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              color: Color(HexColor.toHexCode("#ff5a00")),
              child: Text("Change Password",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () {
                if (newPasswordController1.text ==
                    newPasswordController2.text) {
                  postData(
                      newPasswordController1.text, oldPasswordController.text);

                  setState(() {});
                } else {
                  _showToast("Your passwords do not match!");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void getUserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userID = pref.getString("userID").toString();
    userToken = pref.getString("token").toString();
    setState(() {});
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }
}
