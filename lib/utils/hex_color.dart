import 'dart:ui';

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
var bordaLightGreen = Color(HexColor.toHexCode("#2a4449"));
