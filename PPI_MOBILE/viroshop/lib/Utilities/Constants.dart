import 'package:flutter/material.dart';

class Constants{
  //static const String api = "http://10.0.2.2:8080/api";
  static const String api = "http://192.168.0.94:8080/api";
  static const String apiUser = "$api/user";
  static const String apiShopList = "$api/shops";
  static const String apiShopsInCity = "$apiShopList/area";
  static const String apiProductsInShop = "$api/data/products/basic";

  static const Color background = Color.fromRGBO(234, 239, 245, 1);
  static const Color backgroundWave1 = Color.fromRGBO(185, 180, 222, 1);
  static const Color backgroundWave2 = Color.fromRGBO(156, 201, 225, 1);
  static const Color backgroundWave3 = Color.fromRGBO(179, 209, 225, 1);
  static const Color waveBottom = Color.fromRGBO(244, 249, 255, 1);
  static const Color appBarTheme = Color.fromRGBO(1, 106, 213, 1);
  static const Color accent = Color.fromRGBO(63, 147, 232, 1);
  static const Color accentPlus = Color.fromRGBO(0, 106, 213, 1);
  static const Color standardText = Colors.black;
  static const Color accentText = Color.fromRGBO(0, 112, 226, 0.75);
  static const Color labelText = Color.fromRGBO(177, 177, 177, 1);
  static const Color textBackground = Colors.white;
  static const Color popupBackground = Color.fromRGBO(244, 249, 255, 1);
  static const Color buttonColor = Color.fromRGBO(1, 106, 213, 1);
  static const Color cardColor = Color.fromRGBO(0, 112, 226, 0.15);

  static const Color darkBackground = Color.fromRGBO(46, 48, 50, 1);
  static const Color darkBackgroundWave1 = Color.fromRGBO(45, 45, 51, 0.7);
  static const Color darkBackgroundWave2 = Color.fromRGBO(59, 60, 60, 1);
  static const Color darkBackgroundWave3 = Color.fromRGBO(31, 33, 34, 0.2);
  static const Color darkWaveBottom = Color.fromRGBO(45, 45, 47, 1);
  static const Color darkAppBarTheme = Color.fromRGBO(50, 152, 255, 1);
  static const Color darkAccent = Color.fromRGBO(0, 112, 226, 1);
  static const Color darkAccentPlus = Color.fromRGBO(0, 160, 255, 1);
  static const Color darkStandardText = Colors.white;
  static const Color darkAccentText = Color.fromRGBO(31, 142, 255, 1);
  static const Color darkLabelText = Color.fromRGBO(235, 235, 235, 1);
  static const Color darkTextBackground = Color.fromRGBO(143, 141, 136, 1);
  static const Color darkPopupBackground = Color.fromRGBO(50, 50, 55, 1);
  static const Color darkButtonColor = Color.fromRGBO(1, 106, 213, 1);
  static const Color darkCardColor = Color.fromRGBO(50, 152, 255, 0.18);

  static const double labelFontSize = 0.04;
  static const double accentFontSize = 0.037;
  static const double alertLabelFontSize = 0.03;
  static const double appBarFontSize = 0.055;

  static const List<String> cities = ["Gniezno", "Poznań", "Gdańsk", "Września"];

  static int timeOutTime = 7;

  static const Map<String, String> requestErrors = {
    "usernotfound": "Podany użytkownik nie istnieje",
    "cannotlogin": "Błędne hasło",
    "unknown" : "Wystąpił nieoczekiwany błąd",
    "connfailed" : "Połączenie nieudane",
    "conntimeout" : "Przekroczono limit czasu połączenia",
    "httpexception" : "Wystąpił błąd kontaktu z serwerem"
  };

}