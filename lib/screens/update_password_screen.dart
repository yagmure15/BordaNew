import 'dart:convert';

import 'package:bordatech/HttpRequests/Login/change_password_model.dart';
import 'package:bordatech/screens/login_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

String? userID, url , userToken;

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
      url = "http://10.0.2.2:5000/api/User/UpdatePassword/" + userID!;
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
      body: _passwordTextArea(),
    );
  }

  Widget _passwordTextArea() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Old Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
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
                borderRadius: BorderRadius.circular(10.0),
              ),
              //labelText: 'Password',
              hintText: 'Enter your password!',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "New Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
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
                borderRadius: BorderRadius.circular(10.0),
              ),
              //labelText: 'Password',
              hintText: 'Enter your new password!',
            ),
          ),
          SizedBox(
            height: 10,
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
                borderRadius: BorderRadius.circular(10.0),
              ),
              //labelText: 'Password',
              hintText: 'Enter your new password again!',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              color: Color(HexColor.toHexCode("#ff5a00")),
              child: Text("Change Password",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
              onPressed: () {

               if(newPasswordController1.text == newPasswordController2.text){
                 postData(
                     newPasswordController1.text, oldPasswordController.text);

                 setState(() {}); 
               }else{
                 _showToast("your passwords do not match");
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
