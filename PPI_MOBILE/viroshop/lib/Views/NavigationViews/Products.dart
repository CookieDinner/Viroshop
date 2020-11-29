import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Views/NavigationViews/NavigationViewTemplate.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';

// ignore: must_be_immutable
class Products extends StatefulWidget implements NavigationViewTemplate{
  final StoreNavigationView parent;
  Products(this.parent);
  _ProductsState state = _ProductsState();
  @override
  _ProductsState createState() => state;

  @override
  Future<void> update() {
    print("updating Products");
    return null;
  }
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomTheme().background,
      child: Stack(
        children: [
          BackgroundAnimation(),
          //TODO Lista produktów
          Container(
            child: Column(
              children: [
                CustomAppBar("Lista produktów")
              ],
            ),
          )
        ],
      ),
    );
  }
}
