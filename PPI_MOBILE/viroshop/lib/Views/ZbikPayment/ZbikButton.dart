import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Util.dart';

class ZbikButton extends StatelessWidget {
  String text;
  String text2;

  ZbikButton({this.text = "", this.text2 = "ALTERNATIVE"});

  void consolelog() {
    print('CLICK ' + text2);
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
        width: 140,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: FlatButton(
          onPressed: consolelog,
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
