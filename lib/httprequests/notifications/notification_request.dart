import 'dart:convert';
import 'package:bordatech/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void _showToast(S) {
  Fluttertoast.showToast(msg: S.toString(), toastLength: Toast.LENGTH_SHORT);
}

class HttpServiceForNotification {
  Future<void> setToken(String ApplicationUserId, String userToken, String fcmToken) async {
    final String url = Constants.HTTPURL +
        "/api/Notification/setToken/$ApplicationUserId";
    final res = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
        body: jsonEncode({
          "tokenId": fcmToken,
        }));
    if (res.statusCode >= 200 && res.statusCode < 300) {

    } else {
      throw 'error';
    }
  }

  Future<void> sendNotificationUsingTokenId(String title, String body, String userToken, String fcmToken) async {
    final String url = Constants.HTTPURL +
        "/api/Notification/SendNotificationToUser/$fcmToken";
    final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode({
          "tokenId": fcmToken,
          "title": title,
          "body": body
        }));
    if (res.statusCode == 200) {
      _showToast("Notification Sent!");
    } else {
      _showToast("Notification could not be sent!");
    }
  }

  Future<void> sendNotificationUsingTokenIdList(String title, String body, String userToken, List<String> fcmToken) async {
    final String url = Constants.HTTPURL +
        "/api/Notification/SendNotificationToAllUsersByTokenList";
    final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode({
          "tokenIds": fcmToken,
          "title": title,
          "body": body
        }));
    if (res.statusCode == 200) {
      _showToast("Notification Sent!");
    } else {
      _showToast("Notification could not be sent!");
    }
  }

  Future<void> sendNotificationToAllUsers(String title, String body, String userToken) async {
    final String url = Constants.HTTPURL +
        "/api/Notification/SendNotificationToAllUsers";
    final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode({
          "title": title,
          "body": body
        }));
    if (res.statusCode == 200) {
      _showToast("Notification Sent!");
    } else {
      _showToast("Notification could not be sent!");
    }
  }

  Future<void> sendNotificationToAllUsersWithTopic(String title, String body, String topic, String userToken) async {
    final String url = Constants.HTTPURL +
        "/api/Notification/SendNotificationToAllUsers/$topic";
    final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode({
          "title": title,
          "body": body
        }));
    if (res.statusCode == 200) {
      _showToast("Notification Sent!");
    } else {
      _showToast("Notification could not be sent!");
    }
  }

  Future<void> getAllUsersAndToken(String userToken) async {
    final String url = Constants.HTTPURL +
        "/api/Notification/GetAllTokensAndUsers";
    final res = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
       );
    if (res.statusCode == 200) {

    } else {
      throw "error";
    }
  }
}