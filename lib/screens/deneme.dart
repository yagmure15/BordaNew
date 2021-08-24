import 'dart:convert';


import 'package:bordatech/httprequests/birthdays/birthday_model.dart';
import 'package:bordatech/httprequests/birthdays/birthday_request.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:bordatech/screens/dashboard_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class DenemeScreen extends StatefulWidget {
  @override
  _DenemeScreenState createState() => _DenemeScreenState();
}

class _DenemeScreenState extends State<DenemeScreen> {

  final HttpServiceForBirthday httpService = HttpServiceForBirthday();

String dene = "a";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş ekranı"),
      ),
      body: deneme()
      ,
    );
  }

   deneme (){
     return FutureBuilder(
       future: httpService.getPosts(),
       builder: (BuildContext context, AsyncSnapshot<List<BirthdayModel>?> snapshot) {
         if(snapshot.hasData){
           List<BirthdayModel>? login = snapshot.data;
           return ListView(
             children: login!
                 .map(
                     (BirthdayModel post) => ListTile(
                   title: Text(post.applicationUserId.toString()),
                   subtitle:Text(post.birthday.toString()),
                 )
             ).toList(),
           );
         }
         return Center(child: CircularProgressIndicator());
       },




     );

  }


  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

}
