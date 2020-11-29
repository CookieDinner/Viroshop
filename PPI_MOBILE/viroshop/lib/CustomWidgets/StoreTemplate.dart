import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Store.dart';

class StoreTemplate extends StatelessWidget {
  final Store currentStore;
  StoreTemplate(this.currentStore);
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
          onTap: () => print(currentStore.name),
          splashColor: CustomTheme().accentPlus.withOpacity(0.4),
          highlightColor: CustomTheme().cardColor,
          child: Container(
            height: mediaSize.height * 0.155,
            color: CustomTheme().cardColor.withOpacity(0.17),
            child: Center(
                child: Text(
                  currentStore.name,
                  style: TextStyle(
                    color: CustomTheme().cardColor.withOpacity(1),
                    fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                  ),
                )
            ),
          ),
        ),
      ),
    );
  }
}
