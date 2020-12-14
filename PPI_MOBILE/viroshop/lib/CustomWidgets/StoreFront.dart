import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Shop.dart';

class StoreFront extends StatelessWidget {
  final Shop shop;

  StoreFront(this.shop);

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          mediaSize.width * 0.1,
          mediaSize.height * 0.015,
          mediaSize.width * 0.1,
          mediaSize.height * 0.015),
      child: Container(
        height: mediaSize.height * 0.20,
        color: CustomTheme().cardColor.withOpacity(0.17),
        child: Center(
            child: Text(
              shop.name,
              style: TextStyle(
                  color: CustomTheme().cardColor.withOpacity(1),
                  fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
              ),
              textAlign: TextAlign.center,
            )
        ),
      ),
    );
  }
}
