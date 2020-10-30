import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/Utilities/Constants.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Przypomnij hasło", style: TextStyle(fontWeight: FontWeight.w400),),
              titleSpacing: mediaSize.width * 0.04,
              backgroundColor: Constants.appBarTheme,
            ),
            backgroundColor: Constants.background,
            body: Stack(
              children: [
                BackgroundAnimation(),
                Container(
                  height: mediaSize.height,
                  width: mediaSize.width,
                  child: Center(
                    child: Text("WIP"),
                  ),
                ),
              ],
            )
        )
    );
  }
}
