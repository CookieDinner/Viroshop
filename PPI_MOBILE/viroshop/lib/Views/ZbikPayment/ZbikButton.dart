import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Util.dart';

class ZbikButton extends StatelessWidget {
  String text;
  Function onClick;

  ZbikButton({this.text = "", this.onClick});

  void onButtonClick() {
    if (onClick != null) {
      this.onClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
        width: 140,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: FlatButton(
          onPressed: onButtonClick,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
          ),
          color: Colors.lightGreenAccent,
          height: 100,
        ));
  }
}
