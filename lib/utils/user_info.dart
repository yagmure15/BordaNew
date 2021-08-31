import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  final String token = "token";
  final String name = "name";
  final String userID = "userID";
  final String departmentId = "departmentId";
  final String expiration = "expiration";
  final String email = "null";
  final String officeId = "officeId";

//set data into shared preferences like this
  Future<void> setAuthToken(String auth_token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.token, auth_token);
  }

//get value from shared preferences
  Future<String> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String auth_token;
    auth_token = (pref.getString(this.token) ?? null)!;
    return auth_token;
  }

  //set data into shared preferences like this
  Future<void> setName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.name, name);
  }

//get value from shared preferences
  Future<String> getName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String name;
    name = (pref.getString(this.name) ?? null)!;
    return name;
  }

  static void getuserName(String name) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name").toString();
  }

  static void setuserName(String name) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("name", name).toString();
  }

  //set data into shared preferences like this
  Future<void> setUserId(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userID, userID);
  }

//get value from shared preferences
  Future<String> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String userID;
    userID = (pref.getString(this.userID) ?? null)!;
    return userID;
  }

  //set data into shared preferences like this
  Future<void> setEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.email, email);
  }

//get value from shared preferences
  Future<String> getEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String email;
    email = (pref.getString(this.email) ?? null)!;
    return email;
  }

  //set data into shared preferences like this
  Future<void> setOfficeId(int officeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(this.officeId, officeId);
  }

//get value from shared preferences
  Future<int> getOfficeId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int officeId;
    officeId = (pref.getInt(this.officeId) ?? null)!;
    return officeId;
  }

  //set data into shared preferences like this
  Future<void> setDepartmentId(int departmentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(this.departmentId, departmentId);
  }

//get value from shared preferences
  Future<int> getDepartmentId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int departmentId;
    departmentId = (pref.getInt(this.departmentId) ?? null)!;
    return departmentId;
  }

  //set data into shared preferences like this
  Future<void> setExpiration(String expiration) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.expiration, expiration);
  }

//get value from shared preferences
  Future<String> getExpiration() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String expiration;
    expiration = (pref.getString(this.expiration) ?? null)!;
    return expiration;
  }
}
