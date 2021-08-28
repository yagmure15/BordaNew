import 'dart:async';
import 'dart:convert';
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

  final String userId;
  final  String userToken;
  final  String  meetingStartDate;
  final String  meetingEndDate;
  final  String  selectedOfficeId;
  final  String  SelectedMeetigRoomId;

  SearchEmployee(this.userId, this.userToken, this.meetingStartDate,
      this.meetingEndDate, this.selectedOfficeId, this.SelectedMeetigRoomId);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchEmployeeState(
      userId,
      userToken,
      meetingStartDate,
        meetingEndDate,
        selectedOfficeId,
        SelectedMeetigRoomId
    );
  }
}

class _SearchEmployeeState extends State<SearchEmployee> {


  String? _userId;
  String? _userToken ;
  String? _meetingStartDate;
  String? _meetingEndDate;
  String? _selectedOfficeId, _SelectedMeetigRoomId;

  _SearchEmployeeState(
      this._userId,
      this._userToken,
      this._meetingStartDate,
      this._meetingEndDate,
      this._selectedOfficeId,
      this._SelectedMeetigRoomId,
     );


  bool isCheck = true;
  String _query = "";
  TextEditingController textEditingController = TextEditingController();

  List<CheckBoxState> itemSearch = [];
  List<ShowAlllEmplooyes>? _allEmplooyesList;
  List<Widget>? cekWidgets = [];
  List<String> officeIdForMeetingAttendance = [];
  List<Departments>? _departmentList;

  List<CheckBoxState> employeeCheckboxList = [];
  List<CheckBoxState> departmentListesi = [];
  List<ColorModel> renkListesi = [ColorModel(title: "", color: Colors.white24)];
  bool deger = true;
  bool isAllCheck = false;
  int sayac = 0;



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
            userId: _allEmplooyesList![i].id.toString(),
            title: _allEmplooyesList![i].departmentId.toString()));
      }
    } else {
      return null;
    }
  }

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.greenAccent,
    Colors.cyan,
    Colors.lime,
    Colors.indigoAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.redAccent,
    Colors.lightGreen,
    Colors.greenAccent,
    Colors.deepOrangeAccent,
    Colors.yellow,
    Colors.white12
  ];
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

      for (int i = 0; i < _departmentList!.length; i++) {
        departmentListesi.add(CheckBoxState(
            name: _departmentList![i].name.toString(),
            title: _departmentList![i].id.toString()));
      }
    } else {
      return null;
    }

    print("STATUS CODE FOR DEPARMENTS " + response.statusCode.toString());
  }
  Future<void> postMeetingRoomRequest(BuildContext context,
      List attendees) async {
    final String apiUrl = Constants.HTTPURL + "/api/rooms/reservations";

    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_userToken",
        },
        body: jsonEncode({
          "organizerId": _userId,
          "attendees": attendees,
          "startDate": _meetingStartDate,
          "endDate": _meetingEndDate,
          "meetingRoomId": _SelectedMeetigRoomId
        }));

    if (response.statusCode == 201) {
      final String responsString = response.body;
      print("BODY : " + response.body);
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      _showSnackBar(context,"Congrat! Meeting Room is reserved");
    } else {
      _showSnackBar(context,"ERROR! Try Again!");

    }

    print("STATUS CODE FOR MEETING REQUEST : " + response.statusCode.toString());
  }

  @override
  void initState() {
    super.initState();
    getAllEmplooyesByOfficeId();
    getAllDepartmants();

    Timer(Duration(milliseconds: 800), () {
      setState(() {
        employeeCheckboxList = employeeCheckboxList;
      });

      itemSearch.addAll(employeeCheckboxList);

      setDepartmentsColor();
    });
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
        title: Text('Choose Participant'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _SearchBar(),
          Container(
            height: 60,
            margin: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ...departmentListesi.map(buildSingleCheckbox).toList(),
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
              child: Text("Ara",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
              onPressed: () {

                setState(() {
                  officeIdForMeetingAttendance.clear();
                });

                for(int i = 0; i<employeeCheckboxList.length; i++){
                  if(employeeCheckboxList[i].value == true){
                    setState(() {
                      officeIdForMeetingAttendance.add(employeeCheckboxList[i].userId.toString());
                    });
                  }
                }

                postMeetingRoomRequest(context,officeIdForMeetingAttendance);

              },
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
          ...itemSearch.map(_checkboxListBuildForUsers).toList(),
        ],
      ),
    );
  }

  Widget _checkboxListBuildForUsers(CheckBoxState checkBoxState) {
    return CheckboxListTile(
      title: Text(
        checkBoxState.name,
        style: TextStyle(color: Colors.white),
      ),
      value: checkBoxState.value,
      controlAffinity: ListTileControlAffinity.leading,
      secondary: Icon(
        Icons.person,
        color: getColorByDepartment(checkBoxState),
      ),
      onChanged: (bool? value) {
        setState(() {
          textEditingController.text = "";
          filterSearchResult("");
          _query = "";

            checkBoxState.value = value!;
        });

        setState(() {
          toggleForDepartmentsCheckbox(value, checkBoxState.title);
        });


      },
    );
  }


  void toggleForDepartmentsCheckbox(bool? values, String title) {

    if (values == false) {
      setState(() {
        departmentListesi.forEach((element) {
          if (element.title == title) {
            setState(() {
              element.value = false;
            });
          }
        });
      });

    } else {
      for (int i = 0; i < employeeCheckboxList.length; i++) {
        if (employeeCheckboxList[i].title == title) {
          if (employeeCheckboxList[i].value == true) {
            setState(() {
              isAllCheck = true;
            });

          } else {
            setState(() {
              isAllCheck = false;

            });
            break;
          }
        }
      }

      departmentListesi.forEach((element) {
        if (element.title == title) {
          setState(() {
            element.value = isAllCheck;
          });
        }
      });
    }
  }

  Widget buildSingleCheckbox(CheckBoxState checkBoxState) {
    return Card(
      color: getColorByDepartment(checkBoxState),
      child: SizedBox(
        width: 150,
        child: CheckboxListTile(
          contentPadding: EdgeInsets.all(0),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.redAccent,
          value: checkBoxState.value,
          title: Text(checkBoxState.name),
          onChanged: (value) {
            setState(() {
              checkBoxState.value = value!;
              toggleForEmplooyeCheckbox(value, checkBoxState.title);
            });
          },
        ),
      ),
    );
  }

  void toggleForEmplooyeCheckbox(bool? value, String title) {
    for (int i = 0; i < employeeCheckboxList.length; i++) {
      if (employeeCheckboxList[i].title == title) {
        setState(() {
          employeeCheckboxList[i].value = value!;
        });
      }
    }
  }






































  void setDepartmentsCheckbox(String title) {
    departmentListesi.forEach((element) {
      if (element.title == title) {
        setState(() {
          element.value = isAllCheck;
        });
      }
    });
  }

  void setDepartmentsColor() {
    for (int i = 0; i < renkListesi.length; i++) {
      for (int j = 0; j < _departmentList!.length; j++) {
        if (renkListesi[i].title.contains(_departmentList![j].id.toString())) {
        } else {
          renkListesi.add(ColorModel(
              title: _departmentList![i].id.toString(), color: colors[sayac]));
          sayac++;
          break;
        }
      }
    }
  }

  Color getColorByDepartment(CheckBoxState checkBoxState) {
    Color? color;

    for (int i = 0; i < renkListesi.length; i++) {
      if (checkBoxState.title == renkListesi[i].title) {
        setState(() {
          color = renkListesi[i].color;
        });
        break;
      } else {
        setState(() {
          color = Colors.lightGreen;
        });
      }
    }
    return color!;
  }
}

void _showToast(S) {
  Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
}

class CheckBoxState {
  final String name;
   bool value;
  final String title;
  final userId;

  CheckBoxState({required this.name, this.value = false, required this.title, this.userId});
}

class ColorModel {
  final String title;
  final Color color;

  ColorModel({
    required this.title,
    required this.color,
  });
}
_showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "\u{1F389}  " + msg,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    ),
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      disabledTextColor: Colors.deepPurple,
      onPressed: () {},
    ),
    backgroundColor: Color(HexColor.toHexCode("#ff5a00")),
  ));
}