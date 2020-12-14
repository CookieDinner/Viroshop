import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Util.dart';
import '../Utilities/Constants.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomAlerts{


  static void showAlertDialog(BuildContext context, String title, String body, {bool dismissible = true}) async {
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
      context: context,
      builder: (BuildContext context) {
        timer = Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
        });
        return alert;
      },
    );
    timer?.cancel();
  }
  static showChoiceDialog(BuildContext context, String title, String body, String confirmString, Function function, {List<dynamic> functionArgs}) async{
    AlertDialog alert = AlertDialog(
      backgroundColor: CustomTheme().background,
      title: Center(
          child: Text(title, style: TextStyle(color: CustomTheme().accent),)),
      content: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child: Text(body, textAlign: TextAlign.center,)),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      child: Text("Anuluj", style: TextStyle(color: Colors.blueAccent),),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.all(0),
                    ),
                    FlatButton(
                      child: Text(confirmString, style: TextStyle(color: Colors.deepOrangeAccent),),
                      onPressed: () async{
                        if (functionArgs == null)
                          await function();
                        else
                          await function(functionArgs);
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.all(0),
                    )
                  ],
                ),
              )
            ],
          )
      ),
      elevation: 25,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => alert
    );
  }

  static showLoading(BuildContext context, Function fun) async{

    await showGeneralDialog(
      barrierColor: CustomTheme().isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
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
                      child: SpinKitFadingCircle(
                        color: CustomTheme().accent,
                        size: 70,
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