import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HotdeskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HotdeskScreen();
  }
}

class _HotdeskScreen extends State {
  String? selectedOffice;
  String? selectedDate;
  String? selectedDesk;
  List listDesks = ["No available desk"];
  List listOffice = ["İTÜ Arı 3 -  İstanbul", "IYTE Campus, Teknopark - Izmir"];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hot Desk Reservation"),
        backgroundColor: Color(HexColor.toHexCode("#24343b")),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(HexColor.toHexCode("#2a4449")),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(height: 470, width: 350, child: _getBooking()),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      child: Image(
                    image: AssetImage("assets/hotdesk.png"),
                    height: 120,
                    width: 250,
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
            items: listOffice.map((valueItem) {
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
                child: Text("Choose an Office",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            itemHeight: 48,
            value: selectedOffice,
            onChanged: (newValue) {
              setState(() {
                selectedOffice = newValue as String?;
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

  Widget _SelectDesk() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Choose one of the available desks!',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          DropdownButton(
            items: listDesks.map((valueItem) {
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
                child: Text(selectedDesk.toString(),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            itemHeight: 48,
            onChanged: (newValue) {
              setState(() {
                selectedDesk = newValue as String?;
                _showToast(selectedDesk);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _ReservationSearhButton() {
    GlobalKey _key = GlobalKey();
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
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
          _showToast(selectedDesk);
          _SentInformRequest();
        },
      ),
    );
  }

  Widget _GuestAndPetQuestion() {
    return Container(
      margin: EdgeInsets.only(top: 5),
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
                                color: Color(HexColor.toHexCode("#ff5a00")),
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
                                    color: Color(HexColor.toHexCode("#ff5a00")),
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
            _SelectDesk(),
            _GuestAndPetQuestion(),
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
        //_showToast(formatted);
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
}
