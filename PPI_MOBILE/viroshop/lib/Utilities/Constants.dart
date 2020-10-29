import 'package:flutter/material.dart';

class Constants{
  static const String api = "http://10.0.2.2:8080/api";
  static const String apiUser = "$api/user";

  //Kolory prosiłbym w tej formie, bo IDE podświetla i przejrzyściej jest
  //Google => 'color picker'
  //Można też oczywiście w hexie wtedy w formie Color(0x[hex]), ale
  //nie ma podświetlania wtedy w Studio
  static const Color background = Color.fromRGBO(244, 249, 255, 1);
  static const Color appBarTheme = Color.fromRGBO(66, 132, 192, 1);
  static const Color accent = Color.fromRGBO(203, 190, 255, 1);
  static const Color accentPlus = Color.fromRGBO(172, 151, 252, 1);
  static const Color standardText = Colors.black;
  static const Color accentText = Color.fromRGBO(255, 132, 93, 1);
  static const Color labelText = Color.fromRGBO(177, 177, 177, 1);

  static const double labelFontSize = 0.04;
  static const double accentFontSize = 0.037;
  static const double alertLabelFontSize = 0.03;

  static int timeOutTime = 7;

}