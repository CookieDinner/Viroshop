import 'package:flutter/material.dart';
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
                      width: mediaSize.width * 0.32,
                      child: Text(
                        currentOrder.shop.name,
                        style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.8,
                        ),
                      ),
                    ),
                    Container(
                      width: mediaSize.width * 0.32,
                      child: Text(
                        currentOrder.orderDate.toString(),
                        style: TextStyle(
                          color: CustomTheme().cardColor.withOpacity(1),
                          fontSize: mediaSize.width * Constants.appBarFontSize * 0.8,
                        ),
                      ),
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
