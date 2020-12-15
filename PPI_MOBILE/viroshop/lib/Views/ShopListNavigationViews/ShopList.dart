import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomDrawer.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/CustomWidgets/ShopMenuItem.dart';
import 'package:viroshop/CustomWidgets/ShopTemplate.dart';
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

  _ShopListState shopListState = _ShopListState();

  @override
  _ShopListState createState() => shopListState;

  @override
  Future<void> update() {
    shopListState.stateSet();
    return null;
  }

}

class _ShopListState extends State<ShopList> {
  final ScrollController scrollController = ScrollController();

  List<Shop> filteredShops = [];
  List<Shop> shops = [];
  TextEditingController searchController = TextEditingController();

  void stateSet(){
    setState(() {
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      shops = await DbHandler.getShops();
      filteredShops = List.from(shops);
      setState(() {});
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
    setState(() {

    });
  }

  void pushChosenShop(Shop chosenShop) async{
    Data().currentShop = chosenShop;
    FocusScope.of(context).unfocus();
    CustomAlerts.showLoading(context, (){});
    await sendRequest(chosenShop);

    Navigator.of(context).push(
        CustomPageTransition(
          ShopMenuView(),
          x: 0.0,
          y: 0.0,
        )
    );
  }

  Future<void> sendRequest(Shop chosenShop) async{
    await Requests.GetProductsInShop(chosenShop.id).then(
            (String message) async{
          Navigator.pop(context);
          switch(message){
            case "connfailed":
              CustomAlerts.showAlertDialog(context, "Błąd", "Połączenie nieudane");
              break;
            case "conntimeout":
              CustomAlerts.showAlertDialog(context, "Błąd", "Przekroczono limit czasu połączenia");
              break;
            case "httpexception":
              CustomAlerts.showAlertDialog(context, "Błąd", "Wystąpił błąd kontaktu z serwerem");
              break;
            default:
              await DbHandler.insertToProducts(message);
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
          SingleChildScrollView(child: BackgroundAnimation()),
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
                  child: Scrollbar(
                    radius: Radius.circular(20),
                    thickness: 15,
                    isAlwaysShown: true,
                    controller: scrollController,
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: filteredShops.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return ShopTemplate(filteredShops[index], pushChosenShop);
                        }
                    ),
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     FlatButton(
          //       onPressed: () => refreshShops(),
          //       child: Text("Odśwież", style: TextStyle(color: Colors.white),),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
