import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/NavigationViews/NavigationViewTemplate.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';

class ZbikPaymentView extends StatefulWidget {

  @override
  _ZbikPaymentViewState createState() => _ZbikPaymentViewState();

}

class _ZbikPaymentViewState extends State<ZbikPaymentView> {
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
      height: mediaSize.height,
      width: mediaSize.width,
      color: new Color.fromARGB(200, 60, 210, 50),
      alignment: Alignment.center,
      child: Text(

        "System płatności ŻBIK"
      )
    );
  }

}