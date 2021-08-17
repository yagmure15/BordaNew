import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotificationScreenScreenState();
  }
}

class _NotificationScreenScreenState extends State<NotificationScreen> {
  List itemList = ["Mehmet Baran Nakipoğlu Tenis etkinliği oluşturdu!",
    "Engin Yağmur 17 Ağustos günü ofise geleceğini bildirdi!",
    "Mehmet Baran Nakipoğlu Tenis etkinliği oluşturdu!",
    "Ifrah Saalem Kahve etkinliği oluşturdu!",
    "Eylül Sert Meeting Room etkinliği oluşturdu!",
    "Ç. Burçin Dikbasan 17 Ağustos günü evcil hayvanıyla birlikte ofise geleceğini bildirdi!",
    "Mehmet Baran Nakipoğlu Tenis etkinliği oluşturdu!",
    "Mehmet Baran Nakipoğlu Tenis etkinliği oluşturdu!",
    "Mehmet Baran Nakipoğlu Tenis etkinliği oluşturdu!",
    "Mehmet Baran Nakipoğlu Tenis etkinliği oluşturdu!",
    "Mehmet Baran Nakipoğlu Tenis etkinliği oluşturdu!",
    "Mehmet Baran Nakipoğlu Tenis etkinliği oluşturdu!",
  ];

  List<String> resimler = ["assets/hotdesk.png","assets/meeting2.png","assets/rocket.png"];
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
        title: Text('Notifications'),
        backgroundColor: bordaGreen,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(onSelected: (Selected) {
            setState(() {});
          }, itemBuilder: (context) {
            return {'Events', 'Meeting Rooms', "My Calendar"}
                .map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          })
        ],
      ),
      body: _Notifications(),
    );
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  Widget _Notifications() {
    return Container(
      padding: const EdgeInsets.only(top: 10,bottom: 10,right: 8,left: 8),

      child: ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (context, index) {
          String yol;
            if(index ==0){
            yol = resimler[0];
            }else if (index ==1){
            yol = resimler[1];
             }else if (index ==2){
            yol = resimler[2];
            }else if (index ==3){
              yol = resimler[1];
            }else {
              yol = resimler[0];
            }


            return Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                trailing: Text("11:2$index",style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white
                )),
                leading: Image.asset(

                  yol,
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  "16/08/2021",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                  ),
                ),
                subtitle: Text(
                  itemList[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white
                  ),
                ),
              ),
            );
          }),
    );
  }
}
