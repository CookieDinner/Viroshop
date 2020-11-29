import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';

class CustomAppBar extends StatelessWidget{
  final String title;
  final bool withBackButton;

  CustomAppBar(this.title, {this.withBackButton = true});

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    final buttonSize = mediaSize.height * 27 / mediaSize.width;

    return Container(
      width: mediaSize.width,
      child: Row(
        children: [
          withBackButton ? Container(
            height: buttonSize,
            width: buttonSize,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_sharp,
                size: buttonSize * 0.6,
                color: CustomTheme().appBarTheme,)
            ),
          ) : Container(height: buttonSize,width: mediaSize.width * 0.04,),
          withBackButton ? SizedBox(width: mediaSize.width * 0.01,) :
            SizedBox(width: 0,),
          Text(
            title,
            style: TextStyle(
              fontSize: mediaSize.width * Constants.appBarFontSize,
              color: CustomTheme().appBarTheme,
            ),
          )
        ],
      ),
    );
  }
}
