import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ShowDateDialog extends StatefulWidget{
  @override
  _ShowDateDialog createState() => _ShowDateDialog();

}

class _ShowDateDialog  extends State<ShowDateDialog>{
  DateRangePickerController _dateRangePickerController = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: _buildChild(context),

    );

  }
}

_buildChild(BuildContext context) => Container(

  color: Colors.white,
  height: 400,
  width: 350,
  child: Column(
    children: <Widget>[
      Image.asset('assets/temperature.png', height: 50, width: 50,),
      _DatePicker(),
    ],
  ),



);

Widget _DatePicker(){
  DateRangePickerController _dateRangePickerController = DateRangePickerController();

  return Container(
    margin: EdgeInsets.all(20),
    child: SfDateRangePicker(
      monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
      selectionMode: DateRangePickerSelectionMode.multiple,
      onSelectionChanged: _onSelectionChanged,
      showActionButtons: true,
      controller: _dateRangePickerController,
      onSubmit: (Object val){
      },
      onCancel: (){
        _dateRangePickerController.selectedDates = null;
      },

    ),
  );
}

 void _onSelectionChanged(DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {

  _showToast(dateRangePickerSelectionChangedArgs.value);
}
void _showToast(S) {
  Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_LONG);
}
