import 'dart:async';

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


class _MeetingRoomScreen extends State {
  List<OfficeListModel>? _officeListModelList;
  String? selectedOffice;


  TimeOfDay _dateTimeStart = TimeOfDay.now().replacing(
    minute: 0,
    hour: TimeOfDay.now().hour + 1,
  );
  TimeOfDay _dateTimeEnd = TimeOfDay.now().replacing(
    minute: 0,
    hour: TimeOfDay.now().hour + 2,
  );
  String? selectedDate;
  String? selectedMeetingRoom;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay? time;
  TimeOfDay endTime = TimeOfDay.now();
  String bitis = (TimeOfDay.now().hour + 2).toString() + ":00";
  String baslangic = (TimeOfDay.now().hour + 1).toString() + ":00";

  List listDesks = ["No available desk"];
  List listMeetingRoom = ["A", "B", "C", "D"];

  List gun1 = ["Masa1", "masa 2"];
  List gun2 = ["Masa 5", "Masa 8", "Masa 9"];

  DateTime _startDate = DateTime.now();
  int guestCount = 0;
  DateTime? neyDateformat;
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  bool isPetBrought = false;
  String firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
  List<String> dateArr = [];
  List<String> oneDayArr = [];
  String chooseOnlyOneDay =
      "If you are bringing guests or pets to the office, you should make an appointment for only that day.";
  String chooseAnOffice = "Please, Choose an Office";
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

      print("BODY : " + response.body);

      List<dynamic> body = cnv.jsonDecode(responsString);
      _officeListModelList =
          body.map((dynamic item) => OfficeListModel.fromJson(item)).toList();
      setState(() {});

      setInitialSelectedOffice();
    } else {
      // hata mesajı gösterebilirsin
    }

    print("STATUS CODE FOR OFFICE LIST " + response.statusCode.toString());
    // print(userToken);
  }
  @override
  void initState() {
    super.initState();
    getuserInfo();
    Timer(Duration(milliseconds: 100), () {
      getOffices();

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
      body: _officeListModelList ==null ? Center(
        child: CircularProgressIndicator(),
      ):


      Container(
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
                selectedOffice = newValue as String?;
              });
              getOfficeIdForSearh();
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
          DropdownButton(
            items: listMeetingRoom.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Container(
                    child: Text(valueItem,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ));
            }).toList(),
            isExpanded: true,
            hint: Container(
                padding: EdgeInsets.only(left: 0),
                child: Text("Choose a Meeting Room",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            itemHeight: 48,
            value: selectedMeetingRoom,
            onChanged: (newValue) {
              setState(() {
                selectedMeetingRoom = newValue as String?;
              });
            },
          ),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchEmployee() ));

      _SentInformRequest();
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

  void _SentInformRequest() {
    if (selectedOffice == null) {
      _showSnackBar(context, chooseAnOffice);
    } else {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');

      if ((isPetBrought || guestCount > 0) && dateArr.length > 1) {
        _showSnackBar(context, chooseOnlyOneDay);
      }

      if (dateArr.length == 1) {
        final String formatted =
            formatter.format(DateTime.parse(dateArr[0].toString()));
        // _showToast(formatted);
      }
      if (dateArr.length == 0) {
        final String formatted = formatter.format(DateTime.now());
        //_showT_showToast(formatted);
      }
      if (dateArr.length > 1) {
        for (int i = 0; i < dateArr.length; i++) {
          if (i > 0) {
            dateArr[i] = dateArr[i].toString().replaceFirst(RegExp(' '), '');
          }
          dateArr[i] = formatter.format(DateTime.parse(dateArr[i].toString()));
        }
        //_showToast(dateArr.toString());

      }

      /*

      //verileri gönderme işlemini burada yap!

      */
    }
  }

  void _onSubmitController(Object val) {
    setState(() {
      selectedDate = val.toString();
      firstDate = DateFormat('dd MMMM yyyy, EEEE')
          .format(DateTime.parse(selectedDate.toString()));
    });

    _showToast(selectedDate);
    print(selectedDate);
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
}
