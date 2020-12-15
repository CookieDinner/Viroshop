import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Shop.dart';

class ShopTemplate extends StatefulWidget {
  final Shop currentShop;
  final Function function;
  ShopTemplate(this.currentShop, this.function);

  _ShopTemplateState shopTemplateState = _ShopTemplateState();
  @override
  _ShopTemplateState createState() => shopTemplateState;
}

class _ShopTemplateState extends State<ShopTemplate> {
  bool isFavorite = false;

  @override
  void didUpdateWidget(ShopTemplate oldWidget) {
    isFavorite = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          mediaSize.width * 0.1,
          mediaSize.height * 0.015,
          mediaSize.width * 0.1,
          mediaSize.height * 0.015),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.function(widget.currentShop),
          splashColor: CustomTheme().accentPlus.withOpacity(0.4),
          highlightColor: CustomTheme().cardColor,
          child: Container(
            height: mediaSize.height * 0.155,
            color: CustomTheme().cardColor.withOpacity(0.17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: mediaSize.width * 0.02,),
                Icon(Icons.image_not_supported_sharp, size: 70,),
                SizedBox(width: mediaSize.width * 0.03,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.currentShop.name,
                      style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                      ),
                    ),
                    SizedBox(height: mediaSize.height * 0.005,),
                    Text(
                      "ul. " + widget.currentShop.street,
                      style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                      ),
                    ),
                    SizedBox(height: mediaSize.height * 0.005,),
                    Text(
                      widget.currentShop.city,
                      style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: mediaSize.height * 21 / mediaSize.width,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      isFavorite = !isFavorite;
                      setState(() {

                      });
                    },
                    child: isFavorite ?
                    Icon(
                      Icons.star,
                      color: CustomTheme().accentText,
                      size: mediaSize.height * 21 / mediaSize.width,
                    ) :
                    Icon(
                      Icons.star_outline,
                      color: CustomTheme().accentText,
                      size: mediaSize.height * 21 / mediaSize.width,
                    ),
                  ),
                ),
                SizedBox(width: mediaSize.width * 0.06,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}