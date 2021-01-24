import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final int available;
  final double price;
  final int amount;
  final String picture;
  final String unit;
  Product(this.id, this.name, this.category, this.available, this.price, this.picture, this.unit, {this.amount = 0});

  Product.fromJson(Map<String, dynamic> json) :
        id = json["id"],
        name = json["name"],
        category = json["category"],
        available = json["available"] ? 1 : 0,
        price = json["price"],
        amount = 0,
        picture = json["picture"],
        unit = json["unit"] == "PACKAGE" ? "szt" : "kg";

  Product.fromAlleysJson(Map<String, dynamic> json) :
        id = json["id"],
        name = json["name"],
        category = "",
        available = 1,
        price = 0.0,
        amount = 0,
        picture = "",
        unit = "";
}
