import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/StoreMenuItem.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';

class StoreMenuView extends StatefulWidget {
  final storeName;
  StoreMenuView(this.storeName);
  @override
  _StoreMenuViewState createState() => _StoreMenuViewState();
}

class _StoreMenuViewState extends State<StoreMenuView> {
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
                      StoreMenuItem("Lista produktów", (){print(1);}),
                      StoreMenuItem("Kategorie", (){print(2);}),
                      StoreMenuItem("Koszyk", (){print(3);}),
                      StoreMenuItem("Wejdź do\nsklepu / Pozostały czas", (){print(4);}),
                      StoreMenuItem("Mapa sklepu / alejek", (){print(5);}),
                    ],
                  ),
                ),
                CustomAppBar("Menu sklepu ${widget.storeName}"),
              ],
            ),
          )
      ),
    );
  }
}
