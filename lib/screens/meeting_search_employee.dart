import 'dart:async';

import 'package:bordatech/httprequests/departments/departments.dart';
import 'package:bordatech/httprequests/meetingroom/all_emplooyes.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'meeting_room_res_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

class SearchEmployee extends StatefulWidget {
  String? userId,
      userToken,
      meetingStartDate,
      meetingEndDate,
      selectedOfficeId,
      SelectedMeetigRoomId;

  SearchEmployee(this.userId, this.userToken, this.meetingStartDate,
      this.meetingEndDate, this.selectedOfficeId, this.SelectedMeetigRoomId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchEmployeeState();
  }
}

class _SearchEmployeeState extends State<SearchEmployee> {
  bool isCheck = true;
  String _query = "";
  TextEditingController textEditingController = TextEditingController();

  List<CheckBoxState> itemSearch = [];
  List<ShowAlllEmplooyes>? _allEmplooyesList;

  List<Departments>? _departmentList;


  List<CheckBoxState> employeeCheckboxList = [
    CheckBoxState(name: "Mehmet Baran Nakipoğlu ", title: "yazılım"),
  ];
/*
  final department = [
    CheckBoxState(name: "asdasd", title: "yazılım"),
    CheckBoxState(name: "HWD", title: "donanım"),
    CheckBoxState(name: "PMO", title: "pmo"),
    CheckBoxState(name: "ssss", title: "pmo")

  ];
*/



  Future<void> getAllEmplooyesByOfficeId() async {
    setState(() {});

    final String apiUrl = Constants.HTTPURL + "/api/users?officeId=1";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    if (response.statusCode == 200) {
      final String responsString = response.body;
      List<dynamic> body = cnv.jsonDecode(responsString);

      _allEmplooyesList =
          body.map((dynamic item) => ShowAlllEmplooyes.fromJson(item)).toList();

      for (int i = 0; i < _allEmplooyesList!.length; i++) {
        employeeCheckboxList.add(CheckBoxState(
            name: _allEmplooyesList![i].fullName.toString(),
            title: _allEmplooyesList![i].departmentId.toString()));
      }
    } else {
      return null;
    }
  }
  Future<void> getAllDepartmants() async {
    setState(() {});

    final String apiUrl = Constants.HTTPURL + "/api/departments";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    if (response.statusCode == 200) {
      final String responsString = response.body;
      print("BODY FOR DEPARTMENTS: " + response.body);

      List<dynamic> body = cnv.jsonDecode(responsString);

      _departmentList =
          body.map((dynamic item) => Departments.fromJson(item)).toList();

      for (int i = 0; i < _allEmplooyesList!.length; i++) {
        employeeCheckboxList.add(CheckBoxState(
            name: _allEmplooyesList![i].fullName.toString(),
            title: _allEmplooyesList![i].departmentId.toString()));
      }
    } else {
      return null;
    }

    print("STATUS CODE FOR DEPARMENTS " + response.statusCode.toString());
  }

  @override
  void initState() {
    super.initState();
    getAllEmplooyesByOfficeId();
    getAllDepartmants();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        employeeCheckboxList = employeeCheckboxList;
      });

      itemSearch.addAll(employeeCheckboxList);
    });
  }


  final onlySWD = CheckBoxState(name: "SWasdfD", title: "yazılım");
  final onlyHWD = CheckBoxState(name: "HWD", title: "donanım");
  final onlyPMO = CheckBoxState(name: "PMO", title: "pmo");

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
        title: Text('Choose Participant'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _SearchBar(),
          Container(
            height: 60,
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _checkboxForSWD(onlySWD),
                SizedBox(
                  width: 20,
                ),
                _checkboxForHWD(onlyHWD),
                SizedBox(
                  width: 20,
                ),
                _checkboxForPMO(onlyPMO),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: bordaGreen,
              thickness: 1,
            ),
          ),
          _EmployeeListWidget(),
          Container(
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              color: bordaOrange,
              child: Text("Search",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  void filterSearchResult(String query) {
    query = query.toLowerCase().toString();
    List<CheckBoxState> dummyList = [];
    dummyList.addAll(employeeCheckboxList);

    if (query.isNotEmpty) {
      List<CheckBoxState> dummyListData = [];
      dummyList.forEach((element) {
        if (element.name.toLowerCase().contains(query)) {
          dummyListData.add(element);
        }
      });
      setState(() {
        itemSearch.clear();
        itemSearch.addAll(dummyListData);
      });
    } else {
      setState(() {
        itemSearch.clear();
        itemSearch.addAll(employeeCheckboxList);
      });
    }
  }

  Widget _SearchBar() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 0),
      child: TextField(
        textCapitalization: TextCapitalization.none,
        cursorColor: bordaOrange,
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          filterSearchResult(value);
        },
        controller: textEditingController,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: bordaOrange),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: "Search Someone",
            hintStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              height: 0,
            ),
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            )),
      ),
    );
  }

  Widget _EmployeeListWidget() {
    return Expanded(
      child: ListView(
        children: [
          ...itemSearch.map(_checkboxListBuild).toList(),
        ],
      ),
    );
  }

  Widget _checkboxListBuild(CheckBoxState checkBoxState) {
    Color color = Colors.lime;
    if (checkBoxState.title == "yazılım") {
      color = yesil;
    } else if (checkBoxState.title == "donanım") {
      color = sari;
    } else if (checkBoxState.title == "pmo") {
      color = turuncu;
    }
    return CheckboxListTile(
      title: Text(
        checkBoxState.name,
        style: TextStyle(color: Colors.white),
      ),
      value: checkBoxState.value,
      controlAffinity: ListTileControlAffinity.leading,
      secondary: Icon(
        Icons.person,
        color: color,
      ),
      onChanged: (bool? value) {
        setState(() {
          textEditingController.text = "";
          filterSearchResult("");
          _query = "";
          checkBoxState.value = value!;
          _allCheckController(value);
        });
      },
    );
  }

  Widget _checkboxForSWD(CheckBoxState checkBoxState) {
    return Card(
      color: yesil,
      child: SizedBox(
        width: 100,
        child: CheckboxListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            checkBoxState.name,
            style: TextStyle(color: Colors.white),
          ),
          value: checkBoxState.value,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: toggleGroupCheckboxForSWD,
        ),
      ),
    );
  }

  Widget _checkboxForHWD(CheckBoxState checkBoxState) {
    return Card(
      color: sari,
      child: SizedBox(
        width: 100,
        child: CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 00),
          title: Text(
            checkBoxState.name,
            style: TextStyle(color: Colors.white),
          ),
          value: checkBoxState.value,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: toggleGroupCheckboxForHWD,
        ),
      ),
    );
  }

  Widget _checkboxForPMO(CheckBoxState checkBoxState) {
    return Card(
      color: turuncu,
      child: SizedBox(
        width: 100,
        child: CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 00),
          title: Text(
            checkBoxState.name,
            style: TextStyle(color: Colors.white),
          ),
          value: checkBoxState.value,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: toggleGroupCheckboxForPMO,
        ),
      ),
    );
  }

  void toggleGroupCheckboxForSWD(bool? value) {
    if (value == null) return;

    onlySWD.value = value;

    for (int i = 0; i < employeeCheckboxList.length; i++) {
      if (employeeCheckboxList[i].title == "yazılım") {
        setState(() {
          employeeCheckboxList[i].value = value;
        });
      }
    }
  }

  void toggleGroupCheckboxForHWD(bool? value) {
    if (value == null) return;

    onlyHWD.value = value;

    for (int i = 0; i < employeeCheckboxList.length; i++) {
      if (employeeCheckboxList[i].title == "donanım") {
        setState(() {
          employeeCheckboxList[i].value = value;
        });
      }
    }
  }

  void toggleGroupCheckboxForPMO(bool? value) {
    if (value == null) return;

    onlyPMO.value = value;

    for (int i = 0; i < employeeCheckboxList.length; i++) {
      if (employeeCheckboxList[i].title == "pmo") {
        setState(() {
          employeeCheckboxList[i].value = value;
        });
      }
    }
  }

  void _allCheckController(bool value) {
    setState(() {
      for (int i = 0; i < employeeCheckboxList.length; i++) {
        if (employeeCheckboxList[i].title == "yazılım" &&
            employeeCheckboxList[i].value == false) {
          setState(() {
            onlySWD.value = false;
          });
          break;
        } else {
          setState(() {
            onlySWD.value = true;
          });
        }
      }
      for (int i = 0; i < employeeCheckboxList.length; i++) {
        if (employeeCheckboxList[i].title == "donanım" &&
            employeeCheckboxList[i].value == false) {
          setState(() {
            onlyHWD.value = false;
          });
          break;
        } else {
          setState(() {
            onlyHWD.value = true;
          });
        }
      }
      for (int i = 0; i < employeeCheckboxList.length; i++) {
        if (employeeCheckboxList[i].title == "pmo" &&
            employeeCheckboxList[i].value == false) {
          setState(() {
            onlyPMO.value = false;
          });
          break;
        } else {
          setState(() {
            onlyPMO.value = true;
          });
        }
      }
    });
  }
}

void _showToast(S) {
  Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
}

class CheckBoxState {
  final String name;
  bool value;
  final String title;

  CheckBoxState({required this.name, this.value = false, required this.title});
}
