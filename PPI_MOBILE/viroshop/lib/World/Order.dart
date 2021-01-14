import 'package:flutter/material.dart';
import 'package:viroshop/World/Shop.dart';

import 'Product.dart';

class Order {
  final int id;
  final DateTime orderDate;
  final Shop shop;
  final List<Product> products;

  Order(this.id, this.products, this.orderDate, this.shop);

  // Order.fromJson(Map<String, dynamic> json) :
  //       id = json["id"],
  //       name = json["name"],
  //       category = json["category"],
  //       available = json["available"] ? 1 : 0,
  //       price = json["price"];
}
