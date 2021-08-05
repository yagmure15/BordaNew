import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';


class InformResScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _InformResScreen();
  }
}

class _InformResScreen extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Inform Reservation"),
        backgroundColor: Color(HexColor.toHexCode("#24343b")),
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: TextDropdownFormField(

                options: ["Arı 3 - İstanbul", "İzmir"],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    labelText: "Chosee an Office"),

                dropdownHeight: 120,
                onSaved: (a ){
                    _showToast();

                },


              ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlinedButton(onPressed: _showToast, child: Text("tıkla")),
            ],
          )
        ],
      ),
    );
  }

  void _showToast() {
    Fluttertoast.showToast(msg: "asd", toastLength: Toast.LENGTH_LONG);
  }
}
