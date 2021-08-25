import 'dart:async';

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
  String something;
  HotDeskSelectionScreen(this.something);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HotDeskSelectionScreenState(something);
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
        "/api/hotdesks" +
        something;

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJlbmdpbi55YWdtdXJAYm9yZGF0ZWNoLmNvbSIsImp0aSI6IjBlNGE5OTI3LTEyNTUtNGQxOS04NWIyLTVhNDAxNjY5MjFhMCIsImV4cCI6MTYyOTk4Mzc0MCwiaXNzIjoiTVZTIiwiYXVkIjoiQXBpVXNlciJ9.r107fH1mrG6_rjaGXWi_-lOFzXo_RpvlfwiW-_Sy3GA",
      },
    );
    if (response.statusCode == 200) {
      final String responsString = response.body;
      final List<HotdeskModel> list = hotdeskModelFromJson(responsString);

      print(list[5].hotDeskReservations[0].startDate.toString());

      return list;
    } else {
      return null;
    }

    /*

    if (response.statusCode == 200) {
      final String responsString = response.body;
      var jsonData = cnv.jsonDecode(responsString);
      List<HotdeskModel> hotdesks = [];

      for (var i in jsonData) {
        HotdeskModel hotdesk = HotdeskModel(
            id: jsonData["id"],
            name: jsonData["name"],
            hotDeskReservations: jsonData["hotDeskReservations"]);

        hotdesks.add(hotdesk);

        print("hotdesk $i : " + hotdesk.name);

        return hotdesks;
      }
    } else {
      return null;
    }
*/
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
                height: 320,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      color: Colors.black12,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
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
                          } else {}
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
