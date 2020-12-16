import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Views/ShopListNavigationViews/ShopList.dart';

class FavoriteShopList extends ShopList{

  FavoriteShopList(parent, openDrawer): super(parent, openDrawer);

  @override
  final String title = "Ulubione sklepy";

  @override
  Future<void> update() async{
    await getShops();
    shopListState.stateSet();
    return null;
  }

  @override
  Future<void> getShops() async{
    shopListState.shops = await DbHandler.getFavoriteShops();
    favoriteShops = shopListState.shops;
    shopListState.filteredShops = List.from(shopListState.shops);
    shopListState.updateSearch(shopListState.searchController.text);
  }

}
