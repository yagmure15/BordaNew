import 'package:bordatech/httprequests/notifications/notification_request.dart';
import 'package:bordatech/screens/drawer_screen.dart';
import 'package:bordatech/screens/event_res_screen.dart';
import 'package:bordatech/screens/hotdesk_res_screen.dart';
import 'package:bordatech/screens/meeting_room_res_screen.dart';
import 'package:bordatech/screens/notification_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:bordatech/screens/inform_res_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DashboardScreenState();
  }
}

String userId = "";
String officeId = "";
String? userToken;
bool _shouldIgnore = false;
String name = "";

class _DashboardScreenState extends State<DashboardScreen> {

  _lockButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var _date = DateTime.now();
    await prefs.setString('lastPressed', _date.toString());
  }

  void getuserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userId = pref.getString("userID").toString();
      officeId = pref.getInt("officeId").toString();
      userToken = pref.getString("token").toString();
      name = pref.getString("name").toString();
    });
  }

@override
  void initState() {
    super.initState();
    getuserInfo();
    checkShouldIgnore();
  }

  checkShouldIgnore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //DateTime.parse because you can only save Strings locally.
    // .add Adds 12h to the date when the button was last pressed.
    var clickedDate = prefs.getString('lastPressed');
    var _date= DateTime.parse(clickedDate!);
    var currentDate = DateTime.now();
    var nextDate = DateTime(_date.year ,_date.month, _date.day + 1);
    if(currentDate.isBefore(nextDate)){
      setState((){ _shouldIgnore = true; });
    }
    else {
      setState((){ _shouldIgnore = false; });
    }
    print(_shouldIgnore);
  }

/*

    var deneme;
  override
  void initState() {
    bool isDark = true;
    isDark == true ? deneme = bordaOrange: deneme = bordaGreen;
    super.initState();
  }
*/

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: SizedBox(
              height: 30,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: Image(
                  image: AssetImage("assets/borda.png"),
                ),
              )),
        ),

        actions: <Widget>[
          IconButton(

            padding: EdgeInsets.only(right: 16, left: 16),
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));

            },
          ),
          // TODO: delete the pop up
        ],
      ),
      drawer: DrawerScreen(),

      body: _dashboardBody(),
      floatingActionButton: _animatedFloatingButton(),
    );
  }

  Widget _dashboardBody() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 25),
            child: Text(
              "General",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(top: 5, left: 20, right: 20),
          color: bordaGreen,
          elevation: 10.0,
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image(image: AssetImage("assets/audience.png")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Employees",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "35/40",
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image(image: AssetImage("assets/thermometer2.png")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Temperature",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      // TODO: deneme
                      "32°C",
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image(image: AssetImage("assets/hum.png")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Humidity",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "13%",
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 25),
            child: Text(
              "Office Situation",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(top: 5, left: 20, right: 20),
          color: bordaGreen,
          elevation: 10.0,
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image(image: AssetImage("assets/workspaceyellow.png")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Hot Desk",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "20/20",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image(image: AssetImage("assets/meetingroom.png")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Meeting Room",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "4/5",
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image(image: AssetImage("assets/kitchen.png")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Kitchen",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "4/4",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 25),
            child: Text(
              "Requests",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(top: 5, left: 20, right: 20),
          color: bordaGreen,
          elevation: 10.0,
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        HttpServiceForNotification httpreq = new HttpServiceForNotification();
                        httpreq.sendNotificationToAllUsers('Noise Alert', 'Someone has requested to reduce noise!', userToken!);
                         },
                      child: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        radius: 25.0,
                        child:Icon(
                            Icons.volume_off,
                          color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Reduce Noise",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        HttpServiceForNotification httpreq = new HttpServiceForNotification();
                        httpreq.sendNotificationToAllUsers('Happy Hour', '$name has requested for a happy hour! Would you like to join $name?', userToken!);
                        _lockButton();
                        checkShouldIgnore();
                        print(_shouldIgnore);
                        },
                      child: Visibility(
                        visible: _shouldIgnore ? false : true,
                        child: CircleAvatar(
                          backgroundColor: Colors.yellow,
                          radius: 25.0,
                          child:Icon(
                              Icons.wb_sunny_outlined,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: _shouldIgnore ? false : true,
                      child: Text(
                        "Happy Hour",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        _showToast("You have already requested happy hour today!");
                      },
                      child: Visibility(
                        visible: _shouldIgnore ? true : false,
                        child: CircleAvatar(
                          backgroundColor: Colors.white38,
                          radius: 25.0,
                          child:Icon(
                              Icons.wb_sunny_outlined,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: _shouldIgnore ? true : false,
                      child: Text(
                        "Happy Hour",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
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
