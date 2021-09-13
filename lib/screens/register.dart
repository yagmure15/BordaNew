import 'dart:convert';

import 'package:bordatech/httprequests/login/user_login_model.dart';
import 'package:bordatech/httprequests/offices/office_list_model.dart';
import 'package:bordatech/models/register_model.dart';
import 'package:bordatech/screens/dashboard_screen.dart';
import 'package:bordatech/screens/login_screen.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:bordatech/httprequests/offices/office_list_model.dart';

class RegisterScreen extends StatefulWidget {
  String email;
  String password;

  RegisterScreen(
    this.email,
    this.password,
  );
  @override
  _RegisterScreenScreenState createState() {
    return _RegisterScreenScreenState(email, password);
  }
}

void _showToast(S) {
  Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
}

var departments = ['SWD', 'HWD', 'PMO', 'IPS'];
RegisterModel? _user;

class _RegisterScreenScreenState extends State<RegisterScreen> {
  Future<RegisterModel?> postData(
      String fullName,
      DateTime birthday,
      String email,
      int officeId,
      int departmentId,
      String beaconMacAddress) async {
    final String apiUrl = Constants.HTTPURL + "/api/users/register";

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName,
          "birthday": birthday.toIso8601String(),
          "email": email,
          "officeId": officeId,
          "departmentId": departmentId,
          "beaconMacAddress": beaconMacAddress,
        }));
    print(response.statusCode);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final String responsString = response.body;
      return registerModelFromJson(responsString);
    } else {
      return null;
    }
  }

  _RegisterScreenScreenState(this.upEmail, this.upPassword);
  TextEditingController fullNameController = TextEditingController();
  String upEmail;
  String upPassword;
  var _selectedDate = DateTime.parse("1969-07-20 20:18:04Z");
  var officeID;
  var departmentID;
  TextEditingController beaconMacAddressController = TextEditingController();

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var selectedOffice;
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
              Container(
                //height: MediaQuery.of(context).size.height / 6,
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 80,
                    child: Image(
                      image: AssetImage("assets/bordaiot.png"),
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 50,
                margin: EdgeInsets.only(
                  bottom: 8,
                ),
                /* padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 10.0), */
                child: TextField(
                  //textAlign: TextAlign.left,
                  controller: fullNameController,
                  style: TextStyle(
                    color: bordaOrange,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    //labelText: 'Email',
                    hintText: 'Enter Your Full Name',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w300, color: bordaOrange),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 50,
                margin: EdgeInsets.only(
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: bordaGreen,
                    ),
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.all(6),
                child: Text(upEmail,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      color: bordaOrange,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              Container(
                  color: Colors.white70,
                  margin: EdgeInsets.only(
                    bottom: 6,
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  height: 40,
                  child: ElevatedButton(
                      child: Text(
                        'Click to set your birthday!',
                      ),
                      onPressed: _pickDateDialog)),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(
                  bottom: 8,
                ),
                child: Text(_selectedDate ==
                        null //ternary expression to check if date is null
                    ? 'No date is chosen!'
                    : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: bordaGreen,
                    ),
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8)),
                height: 40,
                margin: EdgeInsets.only(
                  bottom: 8,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    elevation: 8,
                    //isExpanded: true,
                    iconSize: 30.0,
                    hint: Text("Choose an office",
                        style: TextStyle(
                            color: bordaOrange, fontWeight: FontWeight.w300)),
                    items:
                        <String>['ITU ARI3', 'IYTE Office'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      print(newValue);
                      if (newValue == "ITU Office")
                        setState(() {
                          officeID = 1;
                        });
                      else {
                        officeID = 2;
                      }
                      print(officeID);
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: bordaGreen,
                    ),
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8)),
                height: 40,
                margin: EdgeInsets.only(
                  bottom: 8,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    elevation: 8,
                    //isExpanded: true,
                    iconSize: 30.0,
                    hint: Text("Choose a department",
                        style: TextStyle(
                            color: bordaOrange, fontWeight: FontWeight.w300)),
                    items: departments.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      departmentID =
                          departments.indexOf(newValue.toString()) + 1;
                      print(departmentID);
                    },
                  ),
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 50,
                margin: EdgeInsets.only(
                  bottom: 8,
                ),
                child: TextField(
                  //textAlign: TextAlign.left,
                  controller: beaconMacAddressController,
                  style: TextStyle(
                    color: bordaOrange,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    //labelText: 'Email',
                    hintText: 'Enter Beacon Mac Address',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w300, color: bordaOrange),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: TextButton(
                  onPressed: () async {
                    String fullName = fullNameController.text;

                    if (fullName.isEmpty) {
                      _showToast("Name field cannot be empty!");
                    } /* else if (_selectedDate.isEmpty) {
                      _showToast("Birthday field cannot be empty!");
                    } */
                    else if (officeID.isEmpty) {
                      _showToast("Office field cannot be empty!");
                    } else if (departmentID.isEmpty) {
                      _showToast("Department field cannot be empty!");
                    } else {
                      print(_selectedDate);
                      final RegisterModel? user = await postData(
                          fullName,
                          _selectedDate,
                          upEmail,
                          officeID,
                          departmentID,
                          beaconMacAddressController.toString());

                      setState(() {
                        _user = user;
                      });
                      /* this.fullName,
        this.birthday,
        this.email,
        this.officeId,
        this.departmentId,
        this.beaconMacAddress, */

                      /* setUserValues(
                          officeId: _user!.officeId,
                          fullName: _user!.fullName,
                          name: _user!.userResource.fullName,
                          email: _user!.userResource.email,
                          token: _user!.token,
                          expiration: _user!.expiration.toString(),
                        ); */

                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }
                  },
                  child: FaIcon(FontAwesomeIcons.arrowCircleRight,
                      size: 60, color: bordaOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
