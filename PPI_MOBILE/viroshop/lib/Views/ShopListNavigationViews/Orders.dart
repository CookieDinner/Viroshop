import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ShopListNavigationView.dart';
import 'package:viroshop/Views/ShopListNavigationViewTemplate.dart';

class Orders extends StatefulWidget implements ShopListNavigationViewTemplate{
  final ShopListNavigationView parent;
  final Function openDrawer;
  Orders(this.parent, this.openDrawer);

  _OrdersState ordersState = _OrdersState();
  @override
  _OrdersState createState() => ordersState;

  @override
  Future<void> update() {
    ordersState.stateSet();
    return null;
  }
}

class _OrdersState extends State<Orders> {

  void stateSet(){
    setState(() {
    });
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
          Container(),
          CustomAppBar("Zamówienia",
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
