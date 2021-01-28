import 'dart:convert';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Views/ShopListNavigationViews/ShopList.dart';
import 'package:viroshop/World/Shop.dart';

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
    String response = await Requests.getFavoriteShops();
    List<Shop> tempShops = [];
    for(Map<String, dynamic> singleShop in jsonDecode(response))
      tempShops.add(
          Shop(
              singleShop['id'],
              singleShop['city'],
              singleShop['street'],
              singleShop['number'],
              singleShop['name'],
              singleShop['maxReservationsPerQuarterOfHour'])
      );
    shopListState.shops = List.from(tempShops);
    favoriteShops = shopListState.shops;
    shopListState.updateSearch(shopListState.searchController.text);
  }

}
