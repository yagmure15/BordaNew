import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchEmployee extends StatefulWidget {
  String? userId, userToken, meetingStartDate, meetingEndDate, selectedOfficeId, SelectedMeetigRoomId;


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

  @override
  void initState() {
    itemSearch.addAll(employeeCheckboxList);
    super.initState();
  }

  final department = [
    CheckBoxState(name: "SWD", title: "yazılım"),
    CheckBoxState(name: "HWD", title: "donanım"),
    CheckBoxState(name: "PMO", title: "pmo")
  ];
  final onlySWD = CheckBoxState(name: "SWD", title: "yazılım");
  final onlyHWD = CheckBoxState(name: "HWD", title: "donanım");
  final onlyPMO = CheckBoxState(name: "PMO", title: "pmo");

  final employeeCheckboxList = [
    CheckBoxState(name: "Mehmet Baran Nakipoğlu ", title: "yazılım"),
    CheckBoxState(name: "Eda Aktaş", title: "pmo"),
    CheckBoxState(name: "Eymen Topçuoğlu", title: "yazılım"),
    CheckBoxState(name: "Emine Acar", title: "donanım"),
    CheckBoxState(name: "Barış Esin", title: "pmo"),
    CheckBoxState(name: "Dilara Diz", title: "pmo"),
    CheckBoxState(name: "Ifrah Saleem", title: "yazılım"),
    CheckBoxState(name: "İrem Yaren Aydın", title: "pmo"),
    CheckBoxState(name: "Ata Korkusuz", title: "donanım"),
    CheckBoxState(name: "Berkay Arslan", title: "donanım"),
    CheckBoxState(name: "Zeynep Bilge", title: "donanım"),
    CheckBoxState(name: "Yusuf Savaş", title: "donanım"),
    CheckBoxState(name: "Utku Urkun", title: "donanım"),
    CheckBoxState(name: "Onat Çınlar", title: "pmo"),
    CheckBoxState(name: "Mehmet Ali Aldıç", title: "pmo"),
    CheckBoxState(name: "Engin Yağmur", title: "yazılım"),
    CheckBoxState(name: "Fatih Onuk", title: "pmo"),
    CheckBoxState(name: "Çağla Burçin Dikbasan", title: "pmo"),
  ];

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
