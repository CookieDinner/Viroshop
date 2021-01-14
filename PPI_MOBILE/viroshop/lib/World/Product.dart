import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final int available;
  final double price;
  Product(this.id, this.name, this.category, this.available, this.price);

  Product.fromJson(Map<String, dynamic> json) :
        id = json["id"],
        name = json["name"],
        category = json["category"],
        available = json["available"] ? 1 : 0,
        price = json["price"];
}
