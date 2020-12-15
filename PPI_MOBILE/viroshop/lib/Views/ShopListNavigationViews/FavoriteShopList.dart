import 'package:flutter/material.dart';
import 'package:viroshop/Views/ShopListNavigationViews/ShopList.dart';

class FavoriteShopList extends ShopList{

  FavoriteShopList(parent, openDrawer): super(parent, openDrawer);

  @override
  final String title = "Ulubione sklepy";
}
