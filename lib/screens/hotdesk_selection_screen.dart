import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HotDeskSelectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HotDeskSelectionScreenState();
  }
}

class _HotDeskSelectionScreenState extends State {

  String _allDataOrEmptyData = "All Desks";
  List allDeskList = ["a", "b", "c", "d"];
  List onlyAvailableDesks = ["d", "e"];

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
      body: Center(
        child: Container(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: _showDesks()),
        ),
      )
    );
  }
  _showDesks(){
    if(_allDataOrEmptyData == "All Desks"){
       return _Desks(allDeskList);
    }
    else{
      return _Desks(onlyAvailableDesks);
    }

  }
  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  _showDialogFunc(BuildContext context, String string) {
    _showToast(string);
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
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 320,
              ),
            ),
          );
        });
  }


  Widget _Desks(List list) {
    return  ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {

      return GestureDetector(
        onTap: (){
          _showDialogFunc(context, index.toString());
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
                      leading: Image.asset('assets/deskempty.png',color: Colors.greenAccent,),
                      title: Text("Desk ${index+1}"),
                      subtitle: Text("Available " + list[index].toString()),

                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        );


    }



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
}
