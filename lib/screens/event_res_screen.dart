import 'dart:convert';

import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

class CreateEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateEvent();
  }
}

String userId = "";
String officeId = "";
String? userToken;
int? selectedEventTypeId;
String? eventStart, eventEnd;

Future<void> postEventRequest(BuildContext context, String applicationUserId,
    int eventType, String startDate, String endDate, String description) async {
  final String apiUrl = Constants.HTTPURL + "/api/Events/CreateEvent";

  final response = await http.post(Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
      body: jsonEncode({
        "applicationUserId": applicationUserId,
        "eventType": eventType,
        "startDate": startDate,
        "endDate": endDate,
        "description": description
      }));

  if (response.statusCode == 201) {
    final String responsString = response.body;
    print("BODY : " + response.body);
    //Navigator.of(context).pop();

    print("OLDU : ");
  } else {}

  print("STATUS CODE FOR EVENT : " + response.statusCode.toString());
}

class _CreateEvent extends State {
  TextEditingController titleController = new TextEditingController();

  TimeOfDay _dateTimeStart = TimeOfDay.now().replacing(
    minute: 0,
    hour: TimeOfDay.now().hour,
  );

  TimeOfDay _dateTimeEnd = TimeOfDay.now().replacing(
    minute: 0,
    hour: TimeOfDay.now().hour,
  );
  String? selectedTitle;
  String selectedDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());

  List listTitle = [
    "Competition \u{1F3C6}",
    "Meeting \u{1F37A}",
    "Celebration \u{1F381} ",
  ];

  int guestCount = 0;
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  bool isPetBrought = false;
  String firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());

  String chooseOnlyOneDay =
      "If you are bringing guests or pets to the office, you should make an appointment for only that day.";
  String chooseAnOffice = "Please, Choose an Office!";

  @override
  void initState() {
    super.initState();
    getuserInfo();

    selectedDate = DateTime.now().toString();
    selectedTitle = listTitle[0];
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
        title: Text('Create Event'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: _Body(),
    );
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  Widget _EventDescriptionArea() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter a details for the event you will create',
              style: TextStyle(color: Colors.grey, fontSize: 10)),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 2,
            style: TextStyle(
                height: 1.5, fontSize: 16, fontWeight: FontWeight.w500),
            controller: titleController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.5)),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.5)),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _SelectEventTitleArea() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Please select the title of the organization!',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          DropdownButton(
            items: listTitle.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Row(
                    children: [
                      Container(
                        child: Text(valueItem,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ));
            }).toList(),
            isExpanded: true,
            hint: Container(
                padding: EdgeInsets.only(left: 0),
                child: Text("Choose a Title",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            itemHeight: 48,
            value: selectedTitle,
            onChanged: (newValue) {
              setState(() {
                selectedTitle = newValue as String?;
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
          margin: EdgeInsets.only(top: 0),
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
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        color: bordaOrange,
        child: Text("Create",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
        key: _key,
        onPressed: () {
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

  String getTimeString(TimeOfDay date) {
    if (date == null) {
      return "Olmadı";
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
            _SelectEventTitleArea(),
            _DateArea(),
            _Divider(),
            _HoursArea(),
            _Divider(),
            _EventDescriptionArea(),
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
    getEventIdFromList(selectedTitle);
    convertStringToDateIso();
    postEventRequest(context, userId, selectedEventTypeId!, eventStart!,
        eventEnd!, titleController.text.toString());
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

  Widget _Body() {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 50, left: 50, right: 50),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Book a Place',
                      style: TextStyle(
                          color: Colors.black87,
                          backgroundColor: Colors.transparent,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                  _SelectEventTitleArea(),
                  _DateArea(),
                  _Divider(),
                  _HoursArea(),
                  _Divider(),
                  _EventDescriptionArea(),
                  _ReservationSearhButton(),
                ],
              )),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(top: 55),
                alignment: FractionalOffset.bottomCenter,
                child: Image(
                  image: AssetImage("assets/event2.png"),
                ),
                height: 80,
                width: 80,
              ),
            ],
          )
        ],
      ),
    ));
  }

  void getEventIdFromList(name) {
    if (name == listTitle[0]) {
      setState(() {
        selectedEventTypeId = 0;
      });
    } else if (name == listTitle[1]) {
      setState(() {
        selectedEventTypeId = 1;
      });
    } else if (name == listTitle[2]) {
      setState(() {
        selectedEventTypeId = 2;
      });
    }
  }

  void getuserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("userID").toString();
    officeId = pref.getInt("officeId").toString();
    userToken = pref.getString("token").toString();
    setState(() {});
  }

  void convertStringToDateIso() {
    setState(() {
      String date = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(selectedDate.toString()));

      setState(() {
        eventStart = date +
            "T" +
            _dateTimeStart.hour.toString().padLeft(2, "0") +
            ":" +
            _dateTimeStart.minute.toString().padLeft(2, "0") +
            ":00.000Z";

        eventEnd = date +
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
