import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences{

  static late SharedPreferences _preferences;

  static const _keyUserName = "fullname";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserName(String userName) async =>
      await _preferences.setString(_keyUserName, userName);

  static String? getUserName() =>
       _preferences.getString(_keyUserName);


}