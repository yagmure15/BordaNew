import 'package:bordatech/screens/drawer_screen.dart';
import 'package:bordatech/screens/hotdesk_res_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'inform_res_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: SizedBox(
                height: 30,
                child: Container(
                  margin: EdgeInsets.only(left: 40),
                  child: Image(
                    image: AssetImage("assets/borda.png"),
                  ),
                )),
          ),
          backgroundColor: Color(HexColor.toHexCode("#24343b")),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications_active),
              onPressed: () {},
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    child: Text("Ayarlar"),
                  ),
                  const PopupMenuItem(
                    child: Text("Takvim"),
                  )
                ];
              },
            )
          ],
        ),
        drawer: DrawerScreen(),
        backgroundColor: Color(HexColor.toHexCode("#2a4449")),
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
          color: Color(HexColor.toHexCode("#24343b")),
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

                    Image(
                        image: AssetImage("assets/thermometer2.png")),

                    SizedBox(
                      height: 5,
                    ),
                    Text(
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
          color: Color(HexColor.toHexCode("#24343b")),
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
        )
      ],
    );
  }

  Widget _animatedFloatingButton() {
    return SpeedDial(

      overlayColor: Color(HexColor.toHexCode("#24343b")),
      overlayOpacity: 0.5,
      backgroundColor: Color(HexColor.toHexCode("#ff5a00")),
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(

            child: Icon(Icons.event),
            label: "Create Event",
            onTap: () => print("tıklandı")),
        SpeedDialChild(
            child: Icon(Icons.meeting_room),
            label: "Meeting Room Reservation",
            onTap: () => print("tıklandı")),
        SpeedDialChild(
            child: Icon(Icons.desktop_mac),
            label: "Hot Desk Reservation",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HotdeskScreen()));
            }),
        SpeedDialChild(
            child: Icon(Icons.announcement_outlined),
            label: "Inform Reservation",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InformResScreen()));
            }),
      ],
    );
  }

}
