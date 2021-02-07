import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';

class CategoryTemplate extends StatelessWidget {
  final String name;
  final Function function;
  CategoryTemplate(this.name, this.function);
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => function(true, name),
        child: Container(
          height: mediaSize.height * 0.15,
          width: mediaSize.width * 0.4,
          color: CustomTheme().cardColor,
          child: Center(
              child: Text(name[0] + name.substring(1).toLowerCase(),
                style: TextStyle(
                    color: CustomTheme().cardColor.withOpacity(1),
                    fontSize: mediaSize.width * Constants.appBarFontSize * 0.8
                ),)
          ),
        ),
      ),
    );
  }
}
