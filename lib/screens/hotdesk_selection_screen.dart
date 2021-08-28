import 'dart:async';
import 'dart:convert';

import 'package:bordatech/httprequests/hotdesks/hotdesk_model.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert' as cnv;
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HotDeskSelectionScreen extends StatefulWidget {
  String selectedDate;

  HotDeskSelectionScreen(this.selectedDate);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HotDeskSelectionScreenState(selectedDate);
  }
}

String userId = "";
String officeId = "";
String? userToken;
int? selectedEventTypeId;
String? eventStart, eventEnd;

class _HotDeskSelectionScreenState extends State<HotDeskSelectionScreen> {




  Future<List<HotdeskModel>?> _getHotdesks() async {
    final String apiUrl = Constants.HTTPURL +
        "/api/hotdesks/reservations?requestedDate=" + something;

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Bearer $userToken",
      },
    );

    print("STATUS CODE "+ response.statusCode.toString());

    if (response.statusCode == 200) {
      final String responsString = response.body;
      final List<HotdeskModel> list = hotdeskModelFromJson(responsString);

      print("LIST SIZE : " + list.length.toString());

      return list;
    } else {
      return null;
    }
  }







  Future<void> postHotdeskRequest(BuildContext context, String userId, String startDate,String id) async {
    final String apiUrl = Constants.HTTPURL + "/api/hotdesks/" + id +"/reserve";

    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode({
          "userId": userId,
          "startDate": startDate+"T09:00:00.000",
          "endDate": startDate+"T18:00:00.000",
        }));

    if (response.statusCode == 201) {
      final String responsString = response.body;
      print("BODY : " + response.body);
      Navigator.of(context).pop();

      setState(() {
        _allDataOrEmptyData = "All Desks";
      });

      print("OLDU : ");
    } else {}

    print("STATUS CODE FOR EVENT : " + response.statusCode.toString());
  }












  String something;
  _HotDeskSelectionScreenState(this.something);
  String? name;
  String _allDataOrEmptyData = "All Desks";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getuserInfo();
    Timer(Duration(milliseconds: 100), () {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bordaSoftGreen,
      appBar: AppBar(
          leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/return.png')),
          title: Text('Hot Desk Selection'),
          backgroundColor: bordaGreen,
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(onSelected: (Selected) {
              setState(() {
                _allDataOrEmptyData = Selected;
              });
            }, itemBuilder: (context) {
              return {'All Desks', 'Only Available'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            }),
          ]),
      body: Container(
        child: _showDesks(),
      ),
    );
  }

  _showDesks() {
    if (_allDataOrEmptyData == "All Desks") {
      return _allDesks();
    } else {
      return _onlyAvailableDesks();
    }
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  _showDialogFunc(BuildContext context, AsyncSnapshot snapshot, int index) {
    String name, dateStr;
    bool isShowable;
    if (snapshot.data[index].hotDeskReservations.length == 0) {
      name = "Available";
      dateStr = "";
      isShowable = false;
    } else {
      name = snapshot
          .data[index].hotDeskReservations[0].applicationUser.fullName
          .toString();
      dateStr =
          snapshot.data[index].hotDeskReservations[0].startDate.toString();
      isShowable = true;
    }
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 330,
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      color: Colors.black12,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage("assets/informbg.png"),
                              height: 80,
                              width: 80,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              snapshot.data[index].name.toString(),
                              style: GoogleFonts.indieFlower(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Rezervasyon Sahibi",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Rezervason Bilgileri",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            _getDateString(dateStr),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        color: isShowable ? bordaSoftGreen : bordaOrange,
                        child: Text(isShowable ? "Not Available" : "Book Now",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            )),
                        onPressed: () {
                          if (isShowable) {
                            print("DOLUU");
                          } else {

                            postHotdeskRequest(context, userId, something, snapshot.data[index].id.toString());

                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _allDesks() {
    return FutureBuilder(
      future: _getHotdesks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showDialogFunc(context, snapshot, index);
                  },
                  child: Align(
                    widthFactor: 1.5,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            child: Center(
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/deskempty.png',
                                  color: snapshot.data[index]
                                      .hotDeskReservations.length ==
                                      0
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                                title: Text(snapshot.data[index].name,style: TextStyle(color:
                                Colors.black38),),
                                subtitle: Text(snapshot.data[index]
                                    .hotDeskReservations.length ==
                                    0
                                    ? "Available"
                                    : snapshot
                                    .data[index]
                                    .hotDeskReservations[0]
                                    .applicationUser
                                    .fullName
                                    .toString(),style: TextStyle(
                                    fontWeight: FontWeight.w900
                                ),),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
      },
    );
  }

  Widget _onlyAvailableDesks() {
    return FutureBuilder(
      future: _getHotdesks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          int sayac = 0;
          List<HotdeskModel> model = [];
          for (int i = 0; i < snapshot.data.length; i++) {
            if (snapshot.data[i].hotDeskReservations.length == 0) {
              model.add(snapshot.data[i]);
            }
          }
          return ListView.builder(
              itemCount: model.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showDialogFunc(context, snapshot, index);
                  },
                  child: Align(
                    widthFactor: 1.5,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            child: Center(
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/deskempty.png',
                                  color: Colors.greenAccent,
                                ),
                                title: Text(model[index].name,style: TextStyle(color:
                                Colors.black38),),
                                subtitle: Text("Available",style: TextStyle(
                                    fontWeight: FontWeight.w900
                                ),),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
      },
    );
  }

  void _onSelectedMenuItem(String value) {
    switch (value) {
      case 'aaa':
        _showToast("S" + value);
        break;
      case 'Settings':
        _showToast("S" + value);
        break;
    }
  }

  void getuserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("userID").toString();
    officeId = pref.getInt("officeId").toString();
    userToken = pref.getString("token").toString();
    setState(() {});
  }

  String _getDateString(str) {
    if (str == "") {
      return "Available";
    } else {
      return DateFormat("dd MMMM yyyy").format(DateTime.parse(str)) +
          "\n  09:00 -- 18:00";
    }
  }
}
