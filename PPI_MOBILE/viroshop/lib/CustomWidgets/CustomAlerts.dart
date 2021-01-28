import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomAlerts{

  static void showAlertDialog(BuildContext context, String title, String body, {bool dismissible = true, int customTime = 2, Function customFunction}) async {
    final mediaSize = Util.getDimensions(context);
    AlertDialog alert = AlertDialog(
      backgroundColor: CustomTheme().popupBackground,
      title: Center(
          child: Text(title, style: TextStyle(color: CustomTheme().accentText),)),
      content: SizedBox(
          height: mediaSize.height * 0.1,
          child: Center(
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomTheme().standardText
                ),
              )
          )
      ),
      actions: [
      ],
      elevation: 25,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    Timer timer;
    await showDialog(
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        timer = Timer(Duration(seconds: customTime), () {
          if(customFunction == null)
            Navigator.pop(context);
          else
            customFunction();
        });
        return alert;
      },
    );
    timer?.cancel();
  }

  static showLoading(BuildContext context, Function fun) async{
    await showGeneralDialog(
      barrierColor: !CustomTheme().isDark ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.2),
      barrierDismissible: false,
      context: context,
      pageBuilder: (BuildContext context, animation, secondaryAnimation) {
        if (fun != null)
          Future(() => fun());
        else
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        return WillPopScope(
          onWillPop: (){
            return Future<bool>(()=>false);
          },
          child: SafeArea(
              child: Center(
                  child: Container(
                      child: SpinKitFadingCube(
                        color: CustomTheme().buttonColor,
                        size: MediaQuery.of(context).size.width * 0.1,
                      )
                  )
              )
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 150),
    );
  }
}