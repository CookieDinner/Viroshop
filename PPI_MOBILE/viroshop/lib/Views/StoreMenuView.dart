import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/StoreFront.dart';
import 'package:viroshop/CustomWidgets/StoreMenuItem.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';
import 'package:viroshop/World/Shop.dart';

class StoreMenuView extends StatefulWidget {
  StoreMenuView();
  @override
  _StoreMenuViewState createState() => _StoreMenuViewState();
}

class _StoreMenuViewState extends State<StoreMenuView> {

  Shop currentShop = Data().currentShop;

  void pushChosenTab(int index){
    Navigator.of(context).push(
        CustomPageTransition(
          StoreNavigationView(index),
          x: 0.1,
          y: -0.85
        )
    );
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
                BackgroundAnimation(),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: mediaSize.height * 0.1,),
                      StoreFront(currentShop),
                      StoreMenuItem("Lista produktów", () => pushChosenTab(0)),
                      StoreMenuItem("Kategorie", () => pushChosenTab(1)),
                      StoreMenuItem("Koszyk", () => pushChosenTab(2)),
                      // StoreMenuItem("Wejdź do\nsklepu / Pozostały czas", () => pushChosenTab(3)),
                      // StoreMenuItem("Mapa sklepu / alejek", () => pushChosenTab(4)),
                    ],
                  ),
                ),
                CustomAppBar("Menu sklepu"),
              ],
            ),
          )
      ),
    );
  }
}
