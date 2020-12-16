import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ShopListNavigationViewTemplate.dart';
import 'package:viroshop/World/Shop.dart';

class ShopTemplate extends StatefulWidget {
  final Shop currentShop;
  final Function enterShop;
  final Function addToFavorites;
  final ShopListNavigationViewTemplate parent;
  ShopTemplate(this.currentShop, this.enterShop, this.addToFavorites, this.parent);

  _ShopTemplateState shopTemplateState = _ShopTemplateState();
  @override
  _ShopTemplateState createState() => shopTemplateState;
}

class _ShopTemplateState extends State<ShopTemplate> {
  bool isFavorite = false;



  @override
  void didUpdateWidget(ShopTemplate oldWidget){
    isFavorite = widget.parent.favoriteShops.indexWhere((element) => element.id == widget.currentShop.id) == -1 ? false : true;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    isFavorite = widget.parent.favoriteShops.indexWhere((element) => element.id == widget.currentShop.id) == -1 ? false : true;
    super.initState();
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
          onTap: () => widget.enterShop(widget.currentShop),
          splashColor: CustomTheme().accentPlus.withOpacity(0.4),
          highlightColor: CustomTheme().cardColor,
          child: Container(
            height: mediaSize.height * 0.155,
            color: CustomTheme().cardColor.withOpacity(0.17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: mediaSize.width * 0.02,),
                Icon(Icons.image_not_supported_sharp, size: 70, color: Colors.white),
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
                    onPressed: () async{
                      bool isChanging;
                      if (isFavorite)
                        isChanging = await widget.addToFavorites(widget.currentShop, true);
                      else
                        isChanging = await widget.addToFavorites(widget.currentShop, false);
                      if(!isChanging)
                        isFavorite = !isFavorite;
                      setState(() {});
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