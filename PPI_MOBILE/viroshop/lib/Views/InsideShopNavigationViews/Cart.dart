import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/InsideShopNavigationViewTemplate.dart';
import 'package:viroshop/Views/InsideShopNavigationView.dart';

import '../ZbikPayment/ZbikPaymentView.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget implements InsideShopNavigationViewTemplate {
  final InsideShopNavigationView parent;

  Cart(this.parent);

  _CartState state = _CartState();

  @override
  _CartState createState() => state;

  @override
  Future<void> update() {
    print("updating Cart");
    return null;
  }
}

class _CartState extends State<Cart> {
  void openPaymentScreen() {
    Navigator.of(context).push(
        CustomPageTransition(
          ZbikPaymentView(),
          x: 0.0,
          y: 0.5,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
      color: CustomTheme().background,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: BackgroundAnimation()
          ),
          //TODO Koszyk
          Container(
            child: Column(
              children: [
                CustomAppBar(
                  "Koszyk",
                  withOptionButton: true,
                  optionButtonWidget: Text(
                    "Zamów",
                    style: TextStyle(
                      fontSize:
                          mediaSize.width * Constants.appBarFontSize * 0.9,
                      fontWeight: FontWeight.w400,
                      color: CustomTheme().appBarTheme,
                    ),
                  ),
                  optionButtonAction: openPaymentScreen,
                  isTextOptionButton: true,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
