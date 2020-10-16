import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:viroshop/Utilities/Constants.dart';
import 'package:flutter/material.dart';

class Requests{
  Requests();

  static Future<String> PostLogin(String login, String password) async {
    try{
      http.Response response = await http.post(
          "${Constants.test}",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"login" : login, "password" : password})
      ).timeout(Duration(seconds: Constants.timeOutTime));

      return "polaczenie yay";
    }on SocketException{
      debugPrint("Connection failed");
      return "connfailed";
    }on TimeoutException{
      debugPrint("Timeout");
      return "conntimeout";
    }on HttpException{
      debugPrint("Http Exception");
      return "connfailed";
    }
  }
}