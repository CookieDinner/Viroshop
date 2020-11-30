import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Views/NavigationViews/NavigationViewTemplate.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';

// ignore: must_be_immutable
class StoreMap extends StatefulWidget implements NavigationViewTemplate{
  final StoreNavigationView parent;
  StoreMap(this.parent);

  _StoreMapState state = _StoreMapState();
  @override
  _StoreMapState createState() => state;

  @override
  Future<void> update() {
    print("updating StoreMap");
    return null;
  }
}

class _StoreMapState extends State<StoreMap> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomTheme().background,
      child: Stack(
        children: [
          BackgroundAnimation(),
          Container(
            child: Column(
              children: [
                CustomAppBar("Mapa sklepu")
              ],
            ),
          )
        ],
      ),
    );
  }
}
