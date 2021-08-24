import 'package:bordatech/httprequests/offices/office_list_model.dart';
import 'package:bordatech/screens/hotdesk_selection_screen.dart';
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

class HotdeskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HotdeskScreen();
  }
}
String userId = "";
String officeId = "";
String? userToken;
String? selectedOfficeId;


class _HotdeskScreen extends State {

  List<OfficeListModel>? _officeListModelList;
  String? selectedOffice;



  TimeOfDay _dateTimeStart = TimeOfDay.now().replacing(
    minute: 0,
    hour: 9,
  );
  TimeOfDay _dateTimeEnd = TimeOfDay.now().replacing(
    minute: 0,
    hour: 18,
  );

  String? selectedDate;
  String? selectedDesk;

  List listDesks = ["No available desk"];
  List gun1 = ["Masa1", "masa 2"];
  List gun2 = ["Masa 5", "Masa 8", "Masa 9"];

  int guestCount = 0;
  DateTime? neyDateformat;
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  bool isPetBrought = false;
  String firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now().add(Duration(days: 1)));

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
    getOffices();

  }
  @override
  Widget build(BuildContext context) {
    //hangi ofiste çalışıyorsa listeden onu set ediyoruz.
    return Scaffold(
      backgroundColor: bordaSoftGreen,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')),
        title: Text('Hot Desk Reservation'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: _officeListModelList == null ? Center(
        child: CircularProgressIndicator(),
      ):
      Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Container(height: 430, width: 350, child: _getBooking()),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      child: Image(
                        image: AssetImage("assets/hotdesk.png"),
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
      margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            color: bordaOrange,
            child: Text("Choose A Desk",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )),
            key: _key,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HotDeskSelectionScreen()));
              _SentInformRequest();
            },
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: bordaOrange),
                minimumSize: Size(MediaQuery.of(context).size.width, 35)),
            onPressed: () {},
            child: Text("I Feel Lucky",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      ),
    );
  }

  /*
  Widget _GuestAndPetQuestion() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Will you bring a guest/pet to the office?',
              style: TextStyle(color: Colors.grey, fontSize: 10)),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Number of Guests",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (guestCount <= 10 && guestCount > 0) {
                                setState(() {
                                  guestCount -= 1;
                                });
                              }
                            },
                            child: Container(
                              height: 20,
                              child: Icon(
                                Icons.remove,
                                size: 20,
                                color: bordaOrange,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 20,
                            child: Text(guestCount.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                if (guestCount < 10 && guestCount >= 0) {
                                  setState(() {
                                    guestCount += 1;
                                  });
                                }
                              },
                              child: Container(
                                  height: 20,
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: bordaOrange,
                                  ))),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Pet",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 20,
                        child: Checkbox(
                            value: isPetBrought,
                            activeColor: Color(HexColor.toHexCode("#ff5a00")),
                            onChanged: (value) {
                              setState(() {
                                isPetBrought = value!;
                              });
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  */
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
                'Book a Desk',
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
            _HoursArea(),
            _Divider(),
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

  void _SentInformRequest() {}

  void _onSubmitController(Object val) {
    setState(() {
      selectedDate = val.toString();
      firstDate = DateFormat('dd MMMM yyyy, EEEE')
          .format(DateTime.parse(selectedDate.toString()));
    });

    if (selectedDate == "2021-08-13 00:00:00.000") {
      setState(() {
        selectedDesk == null;
        listDesks = gun1;
      });
    }
    if (selectedDate == "2021-08-14 00:00:00.000") {
      setState(() {
        selectedDesk == "asd";
        listDesks = gun2;
      });
    }
    if (selectedDate == "2021-08-15 00:00:00.000") {
      setState(() {
        selectedDesk == "null";

        listDesks = ["a0", "sasd", "asdasdasd"];
      });
    }
    if (selectedDate == "2021-08-16 00:00:00.000") {
      setState(() {
        selectedDesk == "null";
        listDesks = gun2;
      });
    }

    Navigator.of(context).pop(_dateRangePickerController);
  }

  void _onCancelController() {
    Navigator.of(context).pop(_dateRangePickerController);

    setState(() {
      firstDate = DateFormat('dd MMMM yyyy, EEEE')
          .format(DateTime.now().add(Duration(days: 1)));
    });
    selectedDate = firstDate;
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
