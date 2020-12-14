import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:viroshop/Utilities/Constants.dart';
import 'package:flutter/material.dart';

class Requests{
  Requests();

  static Future<String> PostLogin(String login, String password) async {
    try{
      http.Response response = await http.post(
          "${Constants.apiUser}/login",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"login" : login, "password" : password})
      ).timeout(Duration(seconds: Constants.timeOutTime));
      debugPrint(response.body);
      switch(response.body){
        case "Login successful":
          return "loginsuccessful";
        case "User not found":
          return "usernotfound";
        case "Cannot login":
          return "cannotlogin";
        default:
          return "unknown";
      }
    }on SocketException{
      debugPrint("Connection failed");
      return "connfailed";
    }on TimeoutException{
      debugPrint("Timeout");
      return "conntimeout";
    }on HttpException{
      debugPrint("Http Exception");
      return "httpexception";
    }
  }

  static Future<String> PostRegister(String login, String email, String password, String birthDate) async {
    try{
      http.Response response = await http.post(
          "${Constants.apiUser}/register",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"login" : login, "email" : email, "password" : password, "birthDate" : birthDate})
      ).timeout(Duration(seconds: Constants.timeOutTime));
      debugPrint(response.body);
      switch(response.body){
        case "Registered":
          return "registered";
        case "User exists":
          return "userexists";
        default:
          return "unknown";
      }
    }on SocketException{
      debugPrint("Connection failed");
      return "connfailed";
    }on TimeoutException{
      debugPrint("Timeout");
      return "conntimeout";
    }on HttpException{
      debugPrint("Http Exception");
      return "httpexception";
    }
  }

  static Future<String> GetShops() async{
    try{
      http.Response response = await http.get(
          Constants.apiShopList,headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      }
      ).timeout(Duration(seconds: Constants.timeOutTime));

      return response.body;

    }on SocketException{
      debugPrint("Connection failed");
      return "connfailed";
    }on TimeoutException{
      debugPrint("Timeout");
      return "conntimeout";
    }on HttpException{
      debugPrint("Http Exception");
      return "httpexception";
    }
  }
  static Future<String> GetProductsInShop(int id) async{
    try{
      http.Response response = await http.get(
          "${Constants.apiProductsInShop}?shopId=$id",headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      }
      ).timeout(Duration(seconds: Constants.timeOutTime));

      return response.body;

    }on SocketException{
      debugPrint("Connection failed");
      return "connfailed";
    }on TimeoutException{
      debugPrint("Timeout");
      return "conntimeout";
    }on HttpException{
      debugPrint("Http Exception");
      return "httpexception";
    }
  }
}