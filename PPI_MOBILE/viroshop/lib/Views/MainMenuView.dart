import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/CustomWidgets/StoreMenuItem.dart';
import 'package:viroshop/CustomWidgets/StoreTemplate.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/StoreMenuView.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';
import 'package:viroshop/World/Shop.dart';

class MainMenuView extends StatefulWidget {
  final String shops;
  MainMenuView(this.shops);
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  final ScrollController scrollController = ScrollController();

  String shops;
  List<Shop> filteredStores = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    shops = widget.shops;
    List<dynamic> list = jsonDecode(shops);
    list.forEach((element) {
      filteredStores.add(Shop.fromJson(element));
    });
    super.initState();
  }
  void pushChosenStore(Shop chosenStore) async{
    Data().currentShop = chosenStore;
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
        CustomPageTransition(
          StoreMenuView(chosenStore.id, chosenStore.name),
          x: 0.0,
          y: 0.0,
        )
    );
  }

  void refreshShops() async{
    filteredStores.clear();
    String response = await Requests.GetShops();
    List<dynamic> list = jsonDecode(response);
    list.forEach((element) {
      filteredStores.add(Shop.fromJson(element));
    });
    setState(() {});

  }
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: CustomTheme().background,
          body: Container(
            height: mediaSize.height,
            width: mediaSize.width,
            child: Stack(
              children: [
                SingleChildScrollView(child: BackgroundAnimation()),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: mediaSize.height * 0.08,),
                      CustomTextFormField(searchController, "Nazwa/Miasto", TextInputAction.done, (_){}, null),
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
                              itemCount: filteredStores.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return StoreTemplate(filteredStores[index], pushChosenStore);
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomAppBar("Sklepy"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () => refreshShops(),
                      child: Text("Odśwież", style: TextStyle(color: Colors.white),),
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
