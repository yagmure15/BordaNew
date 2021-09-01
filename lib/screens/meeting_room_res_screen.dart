import 'dart:async';

import 'package:bordatech/httprequests/meetingroom/meeting_room_model_by_officeid.dart';
import 'package:bordatech/httprequests/offices/office_list_model.dart';
import 'package:bordatech/screens/meeting_search_employee.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

class MeetingRoomScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MeetingRoomScreen();
  }
}

String userId = "";
String officeId = "";
String? userToken;
String? selectedOfficeId;
String? selectedMeetingRoomId;
String? meetingStart, meetingEnd;

class _MeetingRoomScreen extends State {
  List<OfficeListModel>? _officeListModelList;
  List<MeetingRoomModelByOfficeId>? _meetingRoomModelList;

  String? selectedOffice;

  TimeOfDay _dateTimeStart = TimeOfDay.now().replacing(
    minute: 0,
    hour: TimeOfDay.now().hour,
  );
  TimeOfDay _dateTimeEnd = TimeOfDay.now().replacing(
    minute: 0,
    hour: TimeOfDay.now().hour,
  );
  String? selectedDate =
      DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
  String? selectedMeetingRoom;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay? time;
  TimeOfDay endTime = TimeOfDay.now();
  String bitis = (TimeOfDay.now().hour + 2).toString() + ":00";
  String baslangic = (TimeOfDay.now().hour + 1).toString() + ":00";

  List listDesks = ["No available desk"];

  DateTime _startDate = DateTime.now();
  DateTime? neyDateformat;
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  bool isPetBrought = false;
  String firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
  List<String> dateArr = [];
  String chooseOnlyOneDay =
      "If you are bringing guests or pets to the office, you should make an appointment for only that day.";
  String chooseAnOffice = "Please, Choose an Office";
  String chooseMeetingRoom = "Please, Choose a Meeting Room";

  Future<void> getMeetingRoomsByOfficeId() async {
    setState(() {});

    final String apiUrl = Constants.HTTPURL +
        "api/rooms?officeId=${selectedOfficeId.toString()}&roomType=0";

    //VERİYİ ÇEKMEK İÇİN ALTTAKİ LİNK KULLANILACAK
    //yUKARIDAKİ LİNK TÜM ODALARI GETİRİYOR AMA BİZE SADECE MEETING ROOM OLANLAR LAZIM
    // "api/rooms?officeId=${selectedOfficeId.toString()}&roomType=0";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    if (response.statusCode == 200) {
      final String responsString = response.body;
      print("BODY FOR MEETING ROOM : " + response.body);

      List<dynamic> body = cnv.jsonDecode(responsString);

      _meetingRoomModelList = body
          .map((dynamic item) => MeetingRoomModelByOfficeId.fromJson(item))
          .toList();
    } else {
      return null;
    }

    print("STATUS CODE FOR MEETING ROOM " + response.statusCode.toString());
    // print(userToken);
  }

  Future<void> getOffices() async {
    final String apiUrl = Constants.HTTPURL + "/api/offices";

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
      _officeListModelList =
          body.map((dynamic item) => OfficeListModel.fromJson(item)).toList();
      setState(() {});

      setInitialSelectedOffice();
    } else {
      // hata mesajı gösterebilirsin
    }

    // print(userToken);
  }

  @override
  void initState() {
    super.initState();
    getuserInfo();
    selectedDate = DateTime.now().toString();

    Timer(Duration(milliseconds: 100), () {
      getOffices();
      setInitialSelectedOffice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bordaSoftGreen,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')),
        title: Text('Meeting Room Reservation'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: _officeListModelList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(height: 450, width: 350, child: _getBooking()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          child: Image(
                        image: AssetImage("assets/meeting2.png"),
                        height: 80,
                        width: 80,
                      )),
                    ],
                  ),
                ],
              )),
    );
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  String getTimeString(TimeOfDay date) {
    if (date == null) {
      return "oömadı";
    } else {
      final hours = date.hour.toString().padLeft(2, "0");
      final minute = date.minute.toString().padLeft(2, "0");

      return '$hours:$minute';
    }
  }

  Future<void> _openTimePickerStart(BuildContext context) async {
    final TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _dateTimeStart.hour, minute: 00),
        builder: (context, Widget? child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!);
        });
    if (t != null) {
      setState(() {
        _dateTimeStart = t;
      });
    }
  }

  Future<void> _openTimePickerEnd(BuildContext context) async {
    final TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _dateTimeEnd.hour, minute: 00),
        builder: (context, Widget? child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!);
        });
    if (t != null) {
      setState(() {
        _dateTimeEnd = t;
      });
    }
  }

  Widget _SelectOffice() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Which office do you want to come to?',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          DropdownButton(
            items: _officeListModelList!.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem.name,
                  child: Container(
                    child: Text(valueItem.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ));
            }).toList(),
            isExpanded: true,
            hint: Container(
                padding: EdgeInsets.only(left: 0),
                child: Text("Choose an Office",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            itemHeight: 48,
            value: selectedOffice,
            onChanged: (newValue) {
              setState(() {
                selectedMeetingRoom = null;
                selectedOffice = newValue as String?;
              });
              getOfficeIdForSearh();

              getMeetingRoomsByOfficeId();
            },
          ),
        ],
      ),
    );
  }

  Widget _SelectMeetingRoom() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Which Meeting Room do you want to res to?',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          FutureBuilder(
              future: getMeetingRoomsByOfficeId(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (_meetingRoomModelList == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return DropdownButton(
                    items: _meetingRoomModelList!.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem.name,
                          child: Container(
                            child: Text(valueItem.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ));
                    }).toList(),
                    isExpanded: true,
                    hint: Container(
                        padding: EdgeInsets.only(left: 0),
                        child: Text("Choose a Meeting Room",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                    itemHeight: 48,
                    value: selectedMeetingRoom,
                    onChanged: (newValue) {
                      setState(() {
                        selectedMeetingRoom = newValue as String?;
                        getMeetingRoomIdFromName();
                      });
                    },
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget _DateArea() {
    return GestureDetector(
      onTap: () {
        createDateDialog(context);
      },
      child: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Select Dates',
                  style: TextStyle(color: Colors.grey, fontSize: 10)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 5, 0),
                child: Text(firstDate,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ],
          )),
    );
  }

  Widget _ReservationSearhButton() {
    GlobalKey _key = GlobalKey();
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: MaterialButton(
        color: Color(HexColor.toHexCode("#ff5a00")),
        child: Text("Search",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
        key: _key,
        onPressed: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => SearchEmployee() ));

          _goToSelectionEmplooyePage();
        },
      ),
    );
  }

  Widget _HoursArea() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _openTimePickerStart(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Starting Time',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(getTimeString(_dateTimeStart),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _openTimePickerEnd(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Ending Time',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(getTimeString(_dateTimeEnd),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                  ),
                  flex: 4,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _Divider() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Divider(
          color: Colors.black26,
          height: 1.0,
          thickness: 0.5,
        ));
  }

  Widget _DatePicker() {
    return Container(
      margin: EdgeInsets.all(20),
      child: SfDateRangePicker(
        monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: _onSelectionChanged,
        showActionButtons: true,
        minDate: DateTime.now(),
        maxDate: DateTime.now().add(Duration(days: 7)),
        controller: _dateRangePickerController,
        monthFormat: "MMMM",
        onSubmit: (Object val) {
          _onSubmitController(val);
        },
        onCancel: () {
          _onCancelController();
        },
      ),
    );
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: startTime.hour.toInt() + 1, minute: 00);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );
    if (newTime == null) return;

    setState(() {
      time = newTime;
    });
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs
          dateRangePickerSelectionChangedArgs) {}

  Widget _getBooking() {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Book a Meeting Room',
                style: TextStyle(
                    color: Colors.black87,
                    backgroundColor: Colors.transparent,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
            _SelectOffice(),
            _DateArea(),
            _Divider(),
            _SelectMeetingRoom(),
            _HoursArea(),
            _ReservationSearhButton(),
          ],
        ),
      ),
    );
  }

  createDateDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.deepPurple,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: _buildDateDialogChild(context),
            ));
  }

  _buildDateDialogChild(BuildContext context) => Container(
        color: Colors.white,
        height: 350,
        width: 350,
        child: Column(
          children: <Widget>[
            /* Image.asset(
              'assets/temperature.png',
              height: 50,
              width: 50,
            ), */
            _DatePicker(),
          ],
        ),
      );

  void _goToSelectionEmplooyePage() {
    if (selectedOffice == null) {
      _showSnackBar(context, chooseAnOffice);
    } else if (selectedMeetingRoom == null) {
      _showSnackBar(context, chooseMeetingRoom);
    } else {
      convertStringToDateIso();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchEmployee(

                    userId,
                    userToken!,
                    meetingStart!,
                    meetingEnd!,
                    selectedOfficeId!,
                    selectedMeetingRoomId!,
                  )));
    }
  }

  void _onSubmitController(Object val) {
    setState(() {
      selectedDate = val.toString();
      firstDate = DateFormat('dd MMMM yyyy, EEEE')
          .format(DateTime.parse(selectedDate.toString()));
    });

    Navigator.of(context).pop(_dateRangePickerController);
  }

  void _onCancelController() {
    Navigator.of(context).pop(_dateRangePickerController);

    setState(() {
      firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
    });
    selectedDate = firstDate;
  }

  _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
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

  void getuserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userId = pref.getString("userID").toString();
      officeId = pref.getInt("officeId").toString();
      userToken = pref.getString("token").toString();

      selectedOfficeId = officeId;
    });
  }

  void setInitialSelectedOffice() {
    for (int i = 0; i < _officeListModelList!.length; i++) {
      if (officeId == _officeListModelList![i].id.toString()) {
        setState(() {
          selectedOffice = _officeListModelList![i].name.toString();
        });
        break;
      }
    }
  }

  void getOfficeIdForSearh() {
    for (int i = 0; i < _officeListModelList!.length; i++) {
      if (_officeListModelList![i].name == selectedOffice) {
        setState(() {
          selectedOfficeId = _officeListModelList![i].id.toString();
        });
        break;
      }
    }
  }

  void getMeetingRoomIdFromName() {
    for (int i = 0; i < _meetingRoomModelList!.length; i++) {
      if (selectedMeetingRoom == _meetingRoomModelList![i].name) {
        setState(() {
          selectedMeetingRoomId = _meetingRoomModelList![i].id.toString();
        });

        break;
      }
    }
  }

  void convertStringToDateIso() {
    setState(() {
      String date = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(selectedDate.toString()));

      setState(() {
        meetingStart = date +
            "T" +
            _dateTimeStart.hour.toString().padLeft(2, "0") +
            ":" +
            _dateTimeStart.minute.toString().padLeft(2, "0") +
            ":00.000Z";

        meetingEnd = date +
            "T" +
            _dateTimeEnd.hour.toString().padLeft(2, "0") +
            ":" +
            _dateTimeEnd.minute.toString().padLeft(2, "0") +
            ":00.000Z";
        //1951-11-04T19:35:37.116Z
      });

      // "$y-$m-${d}T$h:$min:$sec.$ms${us}Z"
    });
  }
}
