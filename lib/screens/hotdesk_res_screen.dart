import 'package:bordatech/screens/hotdesk_selection_screen.dart';
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

  int guestCount = 0;
  DateTime? neyDateformat;
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  bool isPetBrought = false;
  String firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
  String chooseOnlyOneDay =
      "If you are bringing guests or pets to the office, you should make an appointment for only that day.";
  String chooseAnOffice = "Please, Choose an Office";

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
        title: Text('Hot Desk Reservation'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(height: 420, width: 350, child: _getBooking()),
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

  Widget _ReservationSearhButton() {
    GlobalKey _key = GlobalKey();
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
      child: MaterialButton(
        color: bordaOrange,
        child: Text("Next",
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
    );
  }

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
