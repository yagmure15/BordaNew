
class  HexColor {
  static toHexCode (String colorHexCode){
    String colorNew = '0xff' + colorHexCode;
    colorNew = colorNew.replaceAll("#", "");
    int color = int.parse(colorNew);
    return color;
  }
}