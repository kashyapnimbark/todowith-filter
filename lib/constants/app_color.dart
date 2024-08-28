import 'package:flutter/material.dart';

class AppColors {
  static Color blackFont = fromHex('#292929');
  static Color textFieldBorder = fromHex('#605E5E');
  static Color textFieldText = fromHex('#605E5E');
  static var grey = Colors.grey.shade400;
  static Color white = fromHex('#FFFFFF');
  static Color brickButtonBG = fromHex('#B78685');
  static Color buttonBgColor = fromHex('#E6DECA');
  static Color sectionText = fromHex('#88A37F');


  static Color fromHex(String? hexString) {
    hexString = hexString ?? "#ECEBEB";
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
