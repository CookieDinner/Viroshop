import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Order.dart';

class OrderTemplate extends StatelessWidget {
  final Order currentOrder;
  final Function function;
  OrderTemplate(this.currentOrder, this.function);

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          mediaSize.width * 0.1,
          mediaSize.height * 0.01,
          mediaSize.width * 0.1,
          mediaSize.height * 0.01),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => function(currentOrder),
          splashColor: CustomTheme().accentPlus.withOpacity(0.4),
          highlightColor: CustomTheme().cardColor,
          child: Container(
            height: mediaSize.height * 0.12,
            color: CustomTheme().cardColor.withOpacity(0.17),
            child: Center(
                child: Row(
                  children: [
                    SizedBox(width: mediaSize.width * 0.04,),
                    Container(
                      width: mediaSize.width * 0.4,
                      child: Text(
                        currentOrder.shop.name + ",\nul."+
                        currentOrder.shop.street + ",\n"+
                        currentOrder.shop.city,
                        style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.8,
                        ),
                      ),
                    ),
                    currentOrder.orderDate != null ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: mediaSize.width * 0.32,
                          child: Text(
                            DateFormat("yyyy-MM-dd").format(currentOrder.orderDate),
                            style: TextStyle(
                              color: CustomTheme().cardColor.withOpacity(1),
                              fontSize: mediaSize.width * Constants.appBarFontSize * 0.8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: mediaSize.width * 0.32,
                          child: Text(
                            (7 + (currentOrder.quarterOfDay / 4).floor()).toString()+":"+
                                (((currentOrder.quarterOfDay % 4) * 15) == 0 ? "00" :
                                ((currentOrder.quarterOfDay % 4) * 15).toString()),
                            style: TextStyle(
                              color: CustomTheme().cardColor.withOpacity(1),
                              fontSize: mediaSize.width * Constants.appBarFontSize * 0.8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ) : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: mediaSize.width * 0.32,
                          child: Text("Mapa produktów",
                            style: TextStyle(
                              color: CustomTheme().cardColor.withOpacity(1),
                              fontSize: mediaSize.width * Constants.appBarFontSize * 0.8,
                            ),
                            textAlign: TextAlign.center,)
                        ),
                      ],
                    ),
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
