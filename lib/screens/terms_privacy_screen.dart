import 'package:bordatech/screens/login_screen.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class TermsPrivacyPolicy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TermsPrivacyPolicyState();
  }
}

class _TermsPrivacyPolicyState extends State<TermsPrivacyPolicy> {
  String _data = "Loading \u{1f60e}";

  Future<void> _loadData() async {
    final _loadedData = await rootBundle.loadString('assets/kvkk.txt');
    setState(() {
      _data = _loadedData;
    });
  }

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 200), () {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')), */
        title: Image.asset(
          "assets/borda.png",
          fit: BoxFit.contain,
          height: 30,
        ),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                padding: EdgeInsets.all(16),
                //color: Colors.white,
                child: Text(
                  _data,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                  strutStyle: StrutStyle(fontSize: 16, height: 1.6),
                ),
                margin: EdgeInsets.only(bottom: 20),
              ),
              Center(
                //padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 150,
                  child: ElevatedButton(
                    child: Text(
                      "Accept",
                      style: TextStyle(
                        color: bordaOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: bordaOrange)))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
