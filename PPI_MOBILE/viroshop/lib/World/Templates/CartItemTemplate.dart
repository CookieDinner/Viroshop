import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/CartItem.dart';
import 'package:viroshop/World/Product.dart';
import 'package:viroshop/World/Shop.dart';

class CartItemTemplate extends StatelessWidget {
  final CartItem currentCartItem;
  final Function function;
  CartItemTemplate(this.currentCartItem, this.function);
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Padding(
      padding: function != null ? EdgeInsets.fromLTRB(mediaSize.width * 0.05, 0, 0, 0) :
      EdgeInsets.fromLTRB(mediaSize.width * 0.05, 0, mediaSize.width * 0.05, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => function != null ? function(currentCartItem.cartProduct, currentCartItem.quantity) : (){},
          splashColor: CustomTheme().accentPlus.withOpacity(0.4),
          highlightColor: CustomTheme().cardColor,
          child: Container(
            height: mediaSize.height * 0.10,
            color: CustomTheme().cardColor.withOpacity(0.17),
            child: Center(
                child: Row(
                  children: [
                    SizedBox(width: mediaSize.width * 0.03,),
                    Container(
                        height: mediaSize.width * 0.13,
                        width: mediaSize.width * 0.13,
                        child: Image.network(currentCartItem.cartProduct.picture)
                    ),
                    SizedBox(width: mediaSize.width * 0.03,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: mediaSize.width * 0.37,
                          child: Text(
                            currentCartItem.cartProduct.name,
                            style: TextStyle(
                              color: CustomTheme().cardColor.withOpacity(1),
                              fontSize: mediaSize.width * Constants.appBarFontSize * 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: mediaSize.width * 0.045,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( "W koszyku: ${currentCartItem.quantity.toInt()} ${currentCartItem.cartProduct.unit}",
                          style: TextStyle(
                            color: CustomTheme().cardColor.withOpacity(1),
                            fontSize: mediaSize.width * Constants.labelFontSize * 0.9,
                          ),
                        ),
                        Container(
                          width: mediaSize.width * 0.28,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text( "Cena: ",
                                style: TextStyle(
                                  color: CustomTheme().cardColor.withOpacity(1),
                                  fontSize: mediaSize.width * Constants.labelFontSize * 0.9,
                                ),
                              ),
                              Expanded(
                                child: Text((currentCartItem.cartProduct.price * currentCartItem.quantity).toStringAsFixed(2) + " zł",
                                  style: TextStyle(
                                    color: CustomTheme().cardColor.withOpacity(1),
                                    fontSize: mediaSize.width * Constants.labelFontSize,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
