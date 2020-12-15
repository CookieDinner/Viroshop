import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Views/InsideShopNavigationViewTemplate.dart';
import 'package:viroshop/Views/InsideShopNavigationView.dart';

// ignore: must_be_immutable
class Categories extends StatefulWidget implements InsideShopNavigationViewTemplate{
  final InsideShopNavigationView parent;
  Categories(this.parent);

  _CategoriesState state = _CategoriesState();
  @override
  _CategoriesState createState() => state;

  @override
  Future<void> update() {
    print("updating Categories");
    return null;
  }
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomTheme().background,
      child: Stack(
        children: [
          BackgroundAnimation(),
          //TODO Kategorie
          Container(
            child: Column(
              children: [
                CustomAppBar("Kategorie")
              ],
            ),
          )
        ],
      ),
    );
  }
}
