import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeColorData extends ChangeNotifier{
  SharedPreferences? _pref;

  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeData get themeColor {
    return _isDark ? lightTheme : darkTheme;
  }

  void toggleTheme(){

    _isDark = !_isDark;
    saveThemeToSharedPref(_isDark);
      notifyListeners();
  }

  Future<void> createSharedPredObject() async {
    _pref = await SharedPreferences.getInstance();
  }

  void saveThemeToSharedPref(bool value){
    _pref!.setBool("theme", value);
  }

  Future<void> loadThemeFromSharedPref() async{
 await createSharedPredObject();
if(_pref!.getBool("theme") == null){

  _isDark = true;

}else {
  _isDark = _pref!.getBool("theme")!;
}

}



}



ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: bordaSoftGreen,
  appBarTheme: AppBarTheme(backgroundColor: bordaGreen),
);
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.green,
  appBarTheme: AppBarTheme(backgroundColor: Colors.redAccent),


);
