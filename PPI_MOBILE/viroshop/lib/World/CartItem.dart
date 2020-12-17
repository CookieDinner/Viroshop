import 'package:flutter/material.dart';
import 'package:viroshop/World/Product.dart';

class CartItem {
  final int id;
  final Product cartProduct;
  final double quantity;
  CartItem(this.id, this.cartProduct, this.quantity);
}
