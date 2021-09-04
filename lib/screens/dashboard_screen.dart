import 'dart:async';
import 'dart:convert';

import 'package:bordatech/httprequests/mycalendar/my_calendar_model.dart';
import 'package:bordatech/httprequests/notifications/notification_request.dart';
import 'package:bordatech/httprequests/offices/general_office_model.dart';
import 'package:bordatech/httprequests/rooms/meeting_room_model.dart';
import 'package:bordatech/models/denememodel.dart';
import 'package:bordatech/screens/drawer_screen.dart';
import 'package:bordatech/screens/event_res_screen.dart';
import 'package:bordatech/screens/hotdesk_res_screen.dart';
import 'package:bordatech/screens/meeting_room_res_screen.dart';
import 'package:bordatech/screens/notification_screen.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:bordatech/screens/inform_res_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DashboardScreenState();
  }
}

List<MeetingRoomsModel>? meetingRoomsList;

List<MeetingRoomsModel>? meeetingdenememodel;

List<MyCalendarModel> myCalendarForHotdesk = [];
String userId = "";
String officeId = "";
String? userToken;
bool _shouldIgnore = false;
String name = "";
String lastPressed = "";
bool isExpanded = false;
MyCalendarModel? _myCalendar;

Future? MeetingFuture, myReservationFuture, officeFuture;
bool isUserHaveHotdeskForToday = false;
int? hotdeskResIndex;
Timer? timer;

class _DashboardScreenState extends State<DashboardScreen> {
  var id;
  var capacity;
  var numberOfPeoplePresent;
  var temperature;
  var humidity;

  var roomId;
  var roomCapacity;
  var roomNumberOfPeoplePresent;
  var roomType;

  var availableHotDesks;

  var totalNumberOfHotDesks;

  Future<void> getOfficeInfo() async {
    await getuserInfo();

    final String apiUrl = Constants.HTTPURL + "api/offices/$officeId/iot";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    var results = jsonDecode(response.body);
    this.id = results["id"];
    this.temperature = results["temperature"];
    this.capacity = results["capacity"];
    this.humidity = results["humidity"];
    this.numberOfPeoplePresent = results["numberOfPeoplePresent"];

    if (response.statusCode == 200) {
      final String responsString = response.body;
      /*
      List<GeneralOfficeModel> body = json.decode(responsString);

      setState(() {
        generalOfficeModel = body
            .map((dynamic item) => GeneralOfficeModel.fromJson(item))
            .toList();

      });

       */

    } else {
      return null;
    }
  }
  Future<void> getHotdeskInfo() async {
    await getuserInfo();

    final String apiUrl = Constants.HTTPURL + "api/hotdesks/availability/$officeId";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    var results = jsonDecode(response.body);
    setState(() {
      this.totalNumberOfHotDesks = results["totalNumberOfHotDesks"];
      this.availableHotDesks = results["availableHotDesks"];
    });


  }

  List<Widget> meetingRoomWidget = [];
  List<Widget> kitchenWidget = [];

  Future<void> removeBySelectedId(String str) async {
    final String apiUrl =
        Constants.HTTPURL + "/api/hotdesks/reservations/$str/cancel";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    setState(() {
      getMyAllReservations();
    });
  }

  Future<void> getMyAllReservations() async {
    await getuserInfo();
    setState(() {});
    String id = "";
    final String apiUrl = Constants.HTTPURL + "api/users/$userId/reservations";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _myCalendar = myCalendarModelFromJson(response.body);
      });
    } else {}

  }

  void checkOutTapped(BuildContext context, int id, String date) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
                                image: AssetImage("assets/3drocket.png"),
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "CHECK OUT",
                                style: GoogleFonts.indieFlower(fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Click to button to check out!",
                                style: GoogleFonts.indieFlower(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              Divider(
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: FloatingActionButton(
                              backgroundColor: bordaOrange,
                              child: Icon(Icons.cancel),
                              onPressed: () async {

                                setState(() {
                                  totalNumberOfHotDesks;
                                  availableHotDesks;
                                });
                                await removeBySelectedId(id.toString());
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> getMeetingRooms() async {
    await getuserInfo();
    setState(() {});
    final String apiUrl = Constants.HTTPURL + "api/rooms/iot/$officeId";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );
    if (response.statusCode == 200) {
      final String results = response.body;
      List<dynamic> body = cnv.jsonDecode(results);

      setState(() {
        meetingRoomsList = body
            .map((dynamic item) => MeetingRoomsModel.fromJson(item))
            .toList();
      });

      meetingRoomsList!.forEach((element) {
        if (element.roomType == 0) {
          meetingRoomWidget.clear();
          meetingRoomWidget.add(Text(
            "Meeting Room :  ${element.numberOfPeoplePresent} / ${element.capacity} ",
            style: TextStyle(
                fontSize: 16,
                color: element.numberOfPeoplePresent == element.capacity
                    ? Colors.red
                    : Colors.lightGreen),
          ));
        } else {
          kitchenWidget.clear();
          kitchenWidget.add(Text(
            "${element.numberOfPeoplePresent}/${element.capacity}",
            style: TextStyle(
                fontSize: 16,
                color: element.numberOfPeoplePresent >= element.capacity
                    ? Colors.red
                    : Colors.lightGreen),
          ));
        }
      });

      for (var i = 0; i < response.body.length; i++) {
        roomId[i] = results[i][0].toString();
      }
    } else {
      return null;
    }

    //  print("STATUS CODE FOR MEETING ROOMS " +
    //    response.statusCode.toString());
  }

  _lockButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var _date = DateTime.now();
    await prefs.setString('lastPressed', _date.toString());
  }

  Future<void> getuserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userId = pref.getString("userID").toString();
      officeId = pref.getInt("officeId").toString();
      userToken = pref.getString("token").toString();
      name = pref.getString("name").toString();
      lastPressed = pref.getString("lastPressed").toString();
      print(lastPressed);
      // getGeneralOfficeInfo();
    });
  }

  @override
  void initState() {
    super.initState();
    checkShouldIgnore();
    getOfficeInfo();

    getHotdeskInfo();
    officeFuture = getOfficeInfo();
    MeetingFuture = getMeetingRooms();
    myReservationFuture = getMyAllReservations();
    Timer.periodic(Duration(seconds: 1), (Timer t) => getOfficeInfo());

    Timer.periodic(Duration(seconds: 5), (Timer t) => getMeetingRooms());
    Timer.periodic(Duration(seconds: 5), (Timer t) => MeetingFuture);
    Timer.periodic(Duration(seconds: 5), (Timer t) => getOfficeInfo());
    Timer.periodic(Duration(seconds: 5), (Timer t) => getHotdeskInfo());

    Timer.periodic(Duration(seconds: 5), (Timer t) => getMyAllReservations());
    Timer.periodic(Duration(seconds: 5), (Timer t) => myReservationFuture);

    // getMyAllReservations();
  }

  checkShouldIgnore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //DateTime.parse because you can only save Strings locally.
    // .add Adds 12h to the date when the button was last pressed.
    var clickedDate = prefs.getString('lastPressed');
    if (clickedDate != null) {
      var _date = DateTime.parse(clickedDate);
      var currentDate = DateTime.now();
      var nextDate = DateTime(_date.year, _date.month, _date.day + 1);
      if (currentDate.isBefore(nextDate)) {
        setState(() {
          _shouldIgnore = true;
        });
      } else {
        setState(() {
          _shouldIgnore = false;
        });
      }
    } else
      setState(() {
        _shouldIgnore = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: SizedBox(
              height: 30,
              child: Container(
                child: Image(
                  image: AssetImage("assets/borda.png"),
                ),
              )),
        ),
        actions: <Widget>[
          /*
          IconButton(
            padding: EdgeInsets.only(right: 16, left: 16),
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
            },
          ),
          */
          // TODO: delete the pop up
        ],
      ),
      drawer: DrawerScreen(),
      body: FutureBuilder(
        future: MeetingFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _dashboardBody();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: _animatedFloatingButton(),
    );
  }

  Widget _dashboardBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 25),
                child: Text(
                  "General Office",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              color: bordaGreen,
              elevation: 10.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image(
                            image: AssetImage("assets/audience.png"),
                            width: 30,
                            height: 30),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Emplooyes",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          numberOfPeoplePresent.toString() +
                              "/" +
                              capacity.toString(),
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/thermometer2.png"),
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Temperature",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          // TODO: deneme
                          "$temperature°C",
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Image(
                            image: AssetImage("assets/hum.png"),
                            height: 32,
                            width: 32),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Humidity",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "$humidity%",
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Column(children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, right: 6),
                            child: Text(
                              "Office Situation",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          margin:
                              EdgeInsets.only(top: 5, bottom: 10, right: 10),
                          color: bordaGreen,
                          elevation: 10.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[


                                Column(
                                  children: <Widget>[
                                    Image(
                                        image: AssetImage(
                                            "assets/workspaceyellow.png"),
                                        height: 30,
                                        width: 30),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Hot Desk",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                        (totalNumberOfHotDesks - availableHotDesks).toString() +"/" +totalNumberOfHotDesks.toString() ,
                                      style: TextStyle(
                                        color: totalNumberOfHotDesks == availableHotDesks ? Colors.red: Colors.lightGreen,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage("assets/kitchen.png"),
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Kitchen",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    kitchenWidget[0],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 8),
                          child: Text(
                            "Request Button",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(top: 5, bottom: 10, left: 10),
                        color: bordaGreen,
                        elevation: 10.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 26),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      HttpServiceForNotification httpreq =
                                          new HttpServiceForNotification();
                                      httpreq.sendNotificationToAllUsers(
                                          'Noise Alert',
                                          'Someone has requested to reduce noise!',
                                          userToken!);
                                    },
                                    child: Visibility(
                                      visible: _shouldIgnore ? true : false,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.orangeAccent,
                                        radius: 20,
                                        child: Icon(Icons.volume_off,
                                            color: Colors.white, size: 25.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Visibility(
                                    visible: _shouldIgnore ? true : false,
                                    child: Text(
                                      "Reduce Noise",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HttpServiceForNotification httpreq =
                                          new HttpServiceForNotification();
                                      httpreq.sendNotificationToAllUsers(
                                          'Noise Alert',
                                          'Someone has requested to reduce noise!',
                                          userToken!);
                                    },
                                    child: Visibility(
                                      visible: _shouldIgnore ? false : true,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.orangeAccent,
                                        radius: 20.0,
                                        child: Icon(Icons.volume_off,
                                            color: Colors.white, size: 25.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Visibility(
                                    visible: _shouldIgnore ? false : true,
                                    child: Text(
                                      "Reduce Noise",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      HttpServiceForNotification httpreq =
                                          new HttpServiceForNotification();
                                      httpreq.sendNotificationToAllUsers(
                                          'Happy Hour',
                                          '$name has requested for a happy hour! Would you like to join $name?',
                                          userToken!);
                                      _lockButton();
                                      checkShouldIgnore();
                                    },
                                    child: Visibility(
                                      visible: _shouldIgnore ? false : true,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.yellow,
                                        radius: 20,
                                        child: Icon(Icons.wb_sunny_outlined,
                                            color: Colors.white, size: 25.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Visibility(
                                    visible: _shouldIgnore ? false : true,
                                    child: Text(
                                      "Happy Hour",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      _showToast(
                                          "You have already requested happy hour today!");
                                    },
                                    child: Visibility(
                                      visible: _shouldIgnore ? true : false,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white38,
                                        radius: 20.0,
                                        child: Icon(Icons.wb_sunny_outlined,
                                            color: Colors.black, size: 25.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Visibility(
                                    visible: _shouldIgnore ? true : false,
                                    child: Text(
                                      "Happy Hour",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ]),
            ),
            SizedBox(height: 15),
            Card(
              margin: EdgeInsets.only(top: 5, bottom: 10, left: 20, right: 20),
              color: bordaGreen,
              elevation: 10.0,
              child: SingleChildScrollView(
                child: Container(
                  child: ExpansionTile(
                    collapsedIconColor: bordaOrange,
                    iconColor: Colors.white,
                    title: Text(
                      "Meeting Rooms",
                      style: TextStyle(color: Colors.white),
                    ),
                    children: [
                      Container(
                        child: ListView.builder(
                          itemCount: meetingRoomWidget.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(20),
                              child: meetingRoomWidget[index],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Card(
              margin: EdgeInsets.only(top: 5, bottom: 10, left: 20, right: 20),
              color: bordaGreen,
              elevation: 10.0,
              child: SingleChildScrollView(
                child: Container(
                  child: ExpansionTile(
                    collapsedIconColor: bordaOrange,
                    iconColor: Colors.white,
                    title: Text(
                      "Check Out",
                      style: TextStyle(color: Colors.white),
                    ),
                    children: [
                      FutureBuilder(
                        future: myReservationFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          DateFormat dateFormat = DateFormat("dd/MM/yyyy");
                          String nowStringDate =
                              dateFormat.format(DateTime.now());

                          for (int i = 0;
                              i < _myCalendar!.hotDeskReservations.length;
                              i++) {
                            DateTime dt =
                                _myCalendar!.hotDeskReservations[i].startDate;
                            String rezerve = dateFormat.format(dt);
                            if (rezerve == nowStringDate &&
                                _myCalendar!
                                        .hotDeskReservations[i].isCancelled ==
                                    false) {
                              hotdeskResIndex = i;
                              print("OLDU");

                              break;
                            } else {
                              hotdeskResIndex = null;

                              print("OLMADI");
                            }
                          }

                          if (hotdeskResIndex == null) {
                            return Container(
                              child: ListTile(
                                title: Text(""),
                              ),
                            );
                          } else {
                            return Container(
                              child: ListTile(
                                onTap: () {
                                  return checkOutTapped(
                                      context,
                                      _myCalendar!
                                          .hotDeskReservations[hotdeskResIndex!]
                                          .id,
                                      "date");
                                },
                                title: Text("Hotdesk Reservation On",style: TextStyle(color: Colors.white),),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedFloatingButton() {
    return SpeedDial(
      overlayColor: bordaGreen,
      overlayOpacity: 0.5,
      backgroundColor: bordaOrange,
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
            child: Icon(Icons.event),
            label: "Create Event",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateEvent()));
            }),
        SpeedDialChild(
            child: Icon(Icons.meeting_room),
            label: "Meeting Room Reservation",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MeetingRoomScreen()));
            }),
        SpeedDialChild(
            child: Icon(Icons.desktop_mac),
            label: "Hot Desk Reservation",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HotdeskScreen()));
            }),
        SpeedDialChild(
            child: Icon(Icons.announcement_outlined),
            label: "Notify of Arrival",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InformResScreen()));
            }),
      ],
    );
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }
}
