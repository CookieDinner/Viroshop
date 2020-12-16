import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomDrawer.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/CustomWidgets/ShopMenuItem.dart';
import 'package:viroshop/World/Templates/ShopTemplate.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ShopListNavigationView.dart';
import 'package:viroshop/Views/ShopListNavigationViewTemplate.dart';
import 'package:viroshop/Views/ShopMenuView.dart';
import 'package:viroshop/Views/InsideShopNavigationView.dart';
import 'package:viroshop/World/Shop.dart';

class ShopList extends StatefulWidget implements ShopListNavigationViewTemplate{
  final ShopListNavigationView parent;
  final Function openDrawer;
  ShopList(this.parent, this.openDrawer);

  final String title = "Sklepy";
  List<Shop> favoriteShops = [];

  _ShopListState shopListState = _ShopListState();

  @override
  _ShopListState createState() => shopListState;

  @override
  Future<void> update() async{
    await getShops();
    shopListState.stateSet();
    return null;
  }

  Future<void> getShops() async{
    favoriteShops = await DbHandler.getFavoriteShops();
    shopListState.shops = await DbHandler.getShops();
    shopListState.filteredShops = List.from(shopListState.shops);
    shopListState.updateSearch(shopListState.searchController.text);
    //shopListState.stateSet();
  }

}

class _ShopListState extends State<ShopList> {
  final ScrollController scrollController = ScrollController();
  StreamController<bool> streamController = StreamController<bool>();

  List<Shop> filteredShops = [];
  List<Shop> shops = [];
  TextEditingController searchController = TextEditingController();
  bool isCurrentlyProcessingFavorites = false;

  void stateSet(){
    setState(() {
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await widget.getShops();
      streamController.add(true);
    });
    super.initState();
  }

  void updateSearch(String text){
    filteredShops = List.from(shops);
    var split = text.split(" ");
    for (String textPart in split)
      filteredShops.retainWhere((element)=>
      (element.name.toUpperCase().startsWith(textPart.toUpperCase()) ||
          element.street.toUpperCase().startsWith(textPart.toUpperCase())));
    setState(() {});
  }

  void pushChosenShop(Shop chosenShop) async{
    Data().currentShop = chosenShop;
    FocusScope.of(context).unfocus();
    CustomAlerts.showLoading(context, (){});
    await sendRequest(chosenShop);
  }

  Future<bool> addToFavorites(Shop shopToAdd, bool shouldDelete) async{
    if (isCurrentlyProcessingFavorites)
      return true;
    else {
      setState(() {isCurrentlyProcessingFavorites = true;});
      if (shouldDelete) {
        await DbHandler.deleteFavoriteShop(shopToAdd);
        await widget.getShops();
        widget.favoriteShops.remove(shopToAdd);
        setState(() {isCurrentlyProcessingFavorites = false;});
        return false;
      } else {
        await DbHandler.insertToFavoriteShops(shopToAdd);
        widget.favoriteShops.add(shopToAdd);
        await widget.getShops();
        setState(() {isCurrentlyProcessingFavorites = false;});
        return false;
      }
    }
  }

  Future<void> sendRequest(Shop chosenShop) async{
    await Requests.GetProductsInShop(chosenShop.id).then(
            (String message) async{
          switch(Constants.requestErrors.containsKey(message)){
            case true:
              Navigator.pop(context);
              CustomAlerts.showAlertDialog(context, "Błąd", Constants.requestErrors[message]);
              break;
            case false:
              await DbHandler.insertToProducts(message);
              Navigator.pop(context);
              Navigator.of(context).push(
                  CustomPageTransition(
                    ShopMenuView(),
                    x: 0.0,
                    y: 0.0,
                  )
              );
              break;
          }
        });
  }

  void refreshShops() async{
    filteredShops.clear();
    String response = await Requests.GetShops();
    await DbHandler.insertToShops(response);
    filteredShops = await DbHandler.getShops();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
      height: mediaSize.height,
      width: mediaSize.width,
      color: CustomTheme().background,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: BackgroundAnimation()
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: mediaSize.height * 0.08,),
                CustomTextFormField(searchController, "Nazwa sklepu / ulica...",
                  TextInputAction.search, (_){}, null, trailingIcon: Icon(Icons.search),
                  onChangeAction: updateSearch,
                ),
                SizedBox(height: mediaSize.height * 0.02,),
                Expanded(
                  child: StreamBuilder<Object>(
                    stream: streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return DraggableScrollbar.rrect(
                          alwaysVisibleScrollThumb: true,
                          backgroundColor: CustomTheme().accent,
                          heightScrollThumb: filteredShops.length > 4 ?
                          max(mediaSize.height * 2 / filteredShops.length,
                              mediaSize.height * 0.05) : 0,
                          padding: EdgeInsets.all(1),
                          controller: scrollController,
                          child: ListView.builder(
                              controller: scrollController,
                              itemCount: filteredShops.length,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ShopTemplate(filteredShops[index], pushChosenShop, addToFavorites, widget);
                              }
                          ),
                        );
                      else
                        return SpinKitFadingCube(
                          color: CustomTheme().buttonColor,
                          size: MediaQuery.of(context).size.width * 0.1,
                        );
                    }
                  ),
                ),
              ],
            ),
          ),
          CustomAppBar(widget.title,
            withOptionButton: true,
            optionButtonAction: widget.openDrawer,
            optionButtonWidget: Icon(
              Icons.settings,
              size: mediaSize.width * 0.07,
              color: CustomTheme().accentPlus,
            ),
          ),
        ],
      ),
    );
  }
}
