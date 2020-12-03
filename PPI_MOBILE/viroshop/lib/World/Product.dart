import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final bool available;
  Product(this.id, this.name, this.category, this.available);

  Product.fromJson(Map<String, dynamic> json) :
        id = json["id"],
        name = json["name"],
        category = json["category"],
        available = json["available"];
}
