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
        height: mediaSize.height * 0.25,
        color: CustomTheme().cardColor.withOpacity(0.12),
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(mediaSize.width * 0.07),
                  child: Icon(Icons.image_not_supported_sharp, size: 100, color: Colors.white,),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name + ",",
                      style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                      ),
                    ),
                    SizedBox(height: mediaSize.height * 0.01,),
                    Text(
                      "ul. " + shop.street + ",",
                      style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                      ),
                    ),
                    SizedBox(height: mediaSize.height * 0.01,),
                    Text(
                      shop.city,
                      style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
