import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/CustomWidgets/StoreMenuItem.dart';
import 'package:viroshop/CustomWidgets/StoreTemplate.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/StoreMenuView.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';
import 'package:viroshop/World/Shop.dart';

class MainMenuView extends StatefulWidget {
  MainMenuView();
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  final ScrollController scrollController = ScrollController();

  List<Shop> filteredStores = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      filteredStores = await DbHandler.getShops();
      setState(() {});
    });
    // List<dynamic> list = jsonDecode(shops);
    // list.forEach((element) {
    //   filteredStores.add(Shop.fromJson(element));
    // });
    super.initState();
  }
  void pushChosenStore(Shop chosenStore) async{
    Data().currentShop = chosenStore;
    FocusScope.of(context).unfocus();
    CustomAlerts.showLoading(context, (){});
    await sendRequest(chosenStore);

    Navigator.of(context).push(
        CustomPageTransition(
          StoreMenuView(),
          x: 0.0,
          y: 0.0,
        )
    );
  }

  Future<void> sendRequest(Shop chosenStore) async{
    await Requests.GetProductsInShop(chosenStore.id).then(
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
              Navigator.of(context).push(
                  CustomPageTransition(
                    MainMenuView(),
                    x: 0.0,
                    y: 0.4,
                  )
              );
              break;
          }
        });
  }

  void refreshShops() async{
    filteredStores.clear();
    String response = await Requests.GetShops();
    await DbHandler.insertToShops(response);
    filteredStores = await DbHandler.getShops();
    // List<dynamic> list = jsonDecode(response);
    // list.forEach((element) {
    //   filteredStores.add(Shop.fromJson(element));
    // });

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
                      CustomTextFormField(searchController, "Nazwa/Miasto", TextInputAction.done, (_){}, null, trailingIcon: Icon(Icons.search),),
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
