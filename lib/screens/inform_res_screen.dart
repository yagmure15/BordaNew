import 'package:bordatech/utils/dialohg_helper.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:bordatech/utils/show_date_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class InformResScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _InformResScreen();
  }
}

class _InformResScreen extends State {
  String? selectedOffice;
  List listOffice = ["İTÜ Arı 3 -  İstanbul", "IYTE Campus, Teknopark - Izmir"];
  DateTime _startDate = DateTime.now();
  int guestCount = 0;
  DateTime? neyDateformat;
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  bool isPetBrought = false;
  String firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inform Reservation"),
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

                        child: Image(image: AssetImage("assets/informbg.png"),height: 120,width: 250,)),
                  ],
                ),
              ],
            )

      ),
    );
  }

  void _showToast(S) {
    Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  Widget _ReservationSearhButton(){
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
        onPressed: () {  },

      ),
    );
  }
  Widget _PetQuery(){

    return Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Will you bring pet to the office?',
                style: TextStyle(color: Colors.grey, fontSize: 10)),
            Padding(
              padding: const EdgeInsets.only(top : 15),
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
                        onChanged: (value)
                    {
                      setState(() {
                        isPetBrought = value!;
                      });

                      _showToast(isPetBrought.toString());
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
            padding: const EdgeInsets.only(top : 15),
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
                      onTap: (){
                        if(guestCount <= 10 && guestCount > 0) {
                          setState(() {
                            guestCount -=1;
                          });
                        }
                      },
                      child: Container(
                        height: 20,
                        child:Icon(Icons.remove,size: 20,color: Color(HexColor.toHexCode("#ff5a00")),),


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
                          onTap: (){
                            if(guestCount < 10 && guestCount >= 0) {
                              setState(() {
                                guestCount +=1;
                              });
                            }
                          },
                          child: Container(
                              height: 20,
                              child: Icon(Icons.add, size: 20,color:Color(HexColor.toHexCode("#ff5a00")),))),





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
          //bu değişkenleri global tanımlamak gerek
          //her onSubmin ve onCancel işlemimde listeyi boşaltım tekrar doldurmak gerekiyor.!!
          List<String> dateArr = [];
          List<String> oneDayArr = [];

          String str = val.toString();
          str = str.replaceAll("[", "");
          str = str.replaceAll("]", "");
          str.split(",").forEach((element) {
            dateArr.add(element);
          });

          Navigator.of(context).pop(_dateRangePickerController);

          if (dateArr.length == 1) {
            String oneDay = dateArr[0].toString();
            oneDay = oneDay.replaceAll("[", "");
            oneDay = oneDay.replaceAll("]", "");
            oneDay.split(" ").forEach((element) {
              oneDayArr.add(element);
            });
            String getDateformat = oneDayArr[0].toString();
            getDateformat = DateFormat("dd MMMM yyyy, EEEE")
                .format(DateTime.parse(getDateformat));
            _showToast(getDateformat);
            setState(() {
              firstDate = getDateformat;
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

          _showToast(dateArr[0]);
        },
        onCancel: () {
          _dateRangePickerController.selectedDates = null;
          Navigator.of(context).pop(_dateRangePickerController);
          setState(() {
            firstDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
          });
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
        height: 400,
        width: 350,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/temperature.png',
              height: 50,
              width: 50,
            ),
            _DatePicker(),
          ],
        ),
      );
}
