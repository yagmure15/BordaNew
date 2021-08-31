import 'dart:async';
import 'dart:convert';

import 'package:bordatech/httprequests/notify/notify_of_arrical_model.dart';
import 'package:bordatech/httprequests/offices/office_list_model.dart';
import 'package:bordatech/utils/constants.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:bordatech/utils/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

class InformResScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InformResScreen();
  }
}

String userId = "";
String officeId = "";
String? userToken;
String? selectedOfficeId;
void _showToast(S) {
  Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
}

Future<void> postNotifyRequest(
    BuildContext context,
    int officeId,
    String userId,
    bool petPresence,
    List dateOfArrival,
    int numberOfGuests) async {
  final String apiUrl =
      Constants.HTTPURL + "/api/offices/notification-of-arrivals";

  final response = await http.post(Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
      body: jsonEncode({
        "officeId": officeId,
        "userId": userId,
        "petPresence": petPresence,
        "numberOfGuests": numberOfGuests,
        "dateOfArrival": dateOfArrival
      }));

  if (response.statusCode == 201) {
    final String responsString = response.body;
    print("BODY : " + response.body);
    Navigator.of(context).pop();
    _showSnackBar(context, "Reservation Created");
  } else {}

  // print("STATUS CODE " + response.statusCode.toString());
}

class _InformResScreen extends State {
  List<OfficeListModel>? _officeListModelList;

  String? selectedOffice;

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
        "Authorization": "Bearer $userToken"
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
    Timer(Duration(milliseconds: 200), () {
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
        title: Text('Notify Participation'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: _officeListModelList == null ? Center(
        child: CircularProgressIndicator(),
      ) :

      Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(height: 460, width: 350, child: _getBooking()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            child: Image(
                              image: AssetImage("assets/informbg.png"),
                              height: 80,
                              width: 80,
                            )),
                      ],
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
          _SentInformRequest();
        },
      ),
    );
  }

  Widget _PetQuery() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Will you bring pet to the office?',
                style: TextStyle(color: Colors.grey, fontSize: 10)),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Pet",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    width: 10,
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
        ));
  }

  Widget _GuestQuestion() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Will your guest come?',
                style: TextStyle(color: Colors.grey, fontSize: 10)),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Number of Guests",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    width: 40,
                  ),
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
                    width: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 20,
                    child: Text(guestCount.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    width: 10,
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
        ));
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
        selectionMode: DateRangePickerSelectionMode.multiple,
        onSelectionChanged: _onSelectionChanged,
        showActionButtons: true,
        minDate: DateTime.now(),
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

  Widget _DateArea() {
    return GestureDetector(
      onTap: () {
        /*
          showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime(2022));
    */
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
                'Book a Place',
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
            _GuestQuestion(),
            _Divider(),
            _PetQuery(),
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
            _DatePicker(),
          ],
        ),
      );

  void _SentInformRequest() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (selectedOffice == null) {
      _showSnackBar(context, chooseAnOffice);
    } else {
      if (dateArr.length == 0) {
        final String formatted = formatter.format(DateTime.now());
        dateArr.add(formatted);
      }
      if (dateArr.length == 1) {
        final String formatted =
            formatter.format(DateTime.parse(dateArr[0].toString()));
      }
      if (dateArr.length > 1) {
        for (int i = 0; i < dateArr.length; i++) {
          if (i > 0) {
            dateArr[i] = dateArr[i].toString().replaceFirst(RegExp(' '), '');
          }
          dateArr[i] = formatter.format(DateTime.parse(dateArr[i].toString()));
        }
      }
      if ((isPetBrought || guestCount > 0) && dateArr.length > 1) {
        _showSnackBar(context, chooseOnlyOneDay);
      } else {
        List liste = [];

        for (int i = 0; i < dateArr.length; i++) {
          dateArr[i] = formatter.format(DateTime.parse(dateArr[i].toString()));
          liste.add(dateArr[i]);
        }
        if(selectedOfficeId == null){
          setState(() {
            selectedOfficeId = officeId;
          });

        }
        postNotifyRequest(context, int.parse(selectedOfficeId!) , userId,
            isPetBrought, liste, guestCount);
      }
    }
  }

  void _onSubmitController(Object val) {
    //dateArr ve oneDayArr listelerinde backend için düzenleme yapmak gerekebilir.
    // Tarih listesini nasıl almak istiyorlarsa ona göre formata çevirmeliyiz.
    dateArr.clear();

    String str = val.toString();
    str = str.replaceAll("[", "");
    str = str.replaceAll("]", "");
    str.split(",").forEach((element) {
      dateArr.add(element);
    });

    Navigator.of(context).pop(_dateRangePickerController);

    if (dateArr.length == 1 && val.toString() != "[]") {
      setState(() {
        firstDate = DateFormat("dd MMMM yyyy, EEEE")
            .format(DateTime.parse(dateArr[0].toString()));
      });
    } else if (dateArr.length == 1 && val.toString() == "[]") {
      dateArr.clear();
      setState(() {
        firstDate = DateFormat("dd MMMM yyyy, EEEE").format(DateTime.now());
      });
    }

    if (dateArr.length > 1) {
      setState(() {
        int i = dateArr.length;
        firstDate = i.toString() + " days selected!";
      });
    }
    if (dateArr.length == 0) {
      firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
    }
  }

  void _onCancelController() {
    dateArr.clear();
    //listede backend için düzenleme yapmak gerekebilir.
    // Tarih listesini nasıl almak istiyorlarsa ona göre formata çevirmeliyiz.
    dateArr.add(DateTime.now().toString());
    _dateRangePickerController.selectedDates = [DateTime.now()];
    Navigator.of(context).pop(_dateRangePickerController);
    setState(() {
      firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
    });
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
