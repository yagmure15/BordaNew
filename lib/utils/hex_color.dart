import 'dart:ui';

import 'package:flutter/material.dart';

class HexColor {
  static toHexCode(String colorHexCode) {
    String colorNew = '0xff' + colorHexCode;
    colorNew = colorNew.replaceAll("#", "");
    int color = int.parse(colorNew);
    return color;
  }
}




var bordaGreen = Color(HexColor.toHexCode("#24343b"));
var bordaOrange = Color(HexColor.toHexCode("#f0542d"));
var bordaSoftGreen = Color(HexColor.toHexCode("#2a4449"));
var yesil = Color(HexColor.toHexCode("#2a9d8f"));
var sari = Color(HexColor.toHexCode("#e9c46a"));
var turuncu = Color(HexColor.toHexCode("#6a4c93"));