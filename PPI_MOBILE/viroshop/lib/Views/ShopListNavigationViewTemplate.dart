import 'package:flutter/material.dart';
import 'package:viroshop/Views/ShopListNavigationView.dart';
import 'package:viroshop/World/Shop.dart';

class ShopListNavigationViewTemplate extends Widget{

  final ShopListNavigationView parent;
  ShopListNavigationViewTemplate(this.parent);

  List<Shop> favoriteShops = [];

  Future<void> update() async{

  }

  @override
  Element createElement() {
    throw UnimplementedError();
  }

}