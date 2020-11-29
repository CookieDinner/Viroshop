import 'package:flutter/material.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';

class NavigationViewTemplate extends Widget{

  final StoreNavigationView parent;
  NavigationViewTemplate(this.parent);

  Future<void> update() async{

  }

  @override
  Element createElement() {
    throw UnimplementedError();
  }

}