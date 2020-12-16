import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Product.dart';
import 'package:viroshop/World/Shop.dart';

class ProductTemplate extends StatelessWidget {
  final Product currentProduct;
  final Function function;
  ProductTemplate(this.currentProduct, this.function);
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
          onTap: () => currentProduct.available == 1 ? function() : (){},
          splashColor: currentProduct.available == 1 ?
            CustomTheme().accentPlus.withOpacity(0.4) :
            Colors.transparent,
          highlightColor: currentProduct.available == 1 ?
            CustomTheme().cardColor :
            Colors.transparent,
          child: Container(
            height: mediaSize.height * 0.15,
            color: currentProduct.available == 1 ?
              CustomTheme().cardColor.withOpacity(0.17) :
              Colors.blueGrey.withOpacity(0.17),
            child: Center(
                child: Row(
                  children: [
                    SizedBox(width: mediaSize.width * 0.04,),
                    Icon(Icons.image_not_supported_sharp, color: CustomTheme().standardText, size: 60,),
                    SizedBox(width: mediaSize.width * 0.04,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: mediaSize.width * 0.32,
                          child: Text(
                            currentProduct.name,
                            style: TextStyle(
                              color: currentProduct.available == 1 ? CustomTheme().cardColor.withOpacity(1) : Colors.grey,
                              fontSize: mediaSize.width * Constants.appBarFontSize * 0.8,
                            ),
                          ),
                        ),
                        currentProduct.available == 0 ?
                        Text(
                          "Produkt obecnie niedostępny",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: mediaSize.width * Constants.labelFontSize * 0.9,
                          ),
                        ) : Container()
                      ],
                    ),
                    currentProduct.available == 1 ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( "Cena:",
                          style: TextStyle(
                            color: CustomTheme().cardColor.withOpacity(1),
                            fontSize: mediaSize.width * Constants.labelFontSize,
                          ),
                        ),
                        Container(
                          width: mediaSize.width * 0.22,
                          child: Text(currentProduct.price.toString() + " zł / szt",
                            style: TextStyle(
                              color: CustomTheme().cardColor.withOpacity(1),
                              fontSize: mediaSize.width * Constants.labelFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ) : Container()
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
