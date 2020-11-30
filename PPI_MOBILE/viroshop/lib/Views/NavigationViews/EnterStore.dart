import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Views/NavigationViews/NavigationViewTemplate.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';

// ignore: must_be_immutable
class EnterStore extends StatefulWidget implements NavigationViewTemplate{
  final StoreNavigationView parent;
  EnterStore(this.parent);

  _EnterStoreState state = _EnterStoreState();
  @override
  _EnterStoreState createState() => state;

  @override
  Future<void> update() {
    print("updating EnterStore");
    return null;
  }
}

class _EnterStoreState extends State<EnterStore> {
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
                CustomAppBar("Wejście do sklepu")
              ],
            ),
          )
        ],
      ),
    );
  }
}
