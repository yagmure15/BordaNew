

import 'dart:convert';

import 'package:bordatech/utils/constants.dart';
import 'package:http/http.dart';

import 'birthday_model.dart';

class HttpServiceForBirthday{
final String url = Constants.HTTPURL+"/api/Birthday/getAll";


Future<List<BirthdayModel>?> getPosts() async{

  Response res = await get(Uri.parse(url));

  if(res.statusCode ==200){
    List<dynamic> body = jsonDecode(res.body);

    List<BirthdayModel> birthdayModel = body.map((dynamic item) => BirthdayModel.fromJson(item)).toList();
    return birthdayModel;
  }else {

    throw "OLMADI";
  }


}


}