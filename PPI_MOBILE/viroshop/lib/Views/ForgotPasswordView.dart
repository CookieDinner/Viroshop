import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: CustomTheme().background,
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                width: mediaSize.width,
                height: mediaSize.height,
                child: Stack(
                  children: [
                    BackgroundAnimation(),
                    Container(
                      height: mediaSize.height,
                      width: mediaSize.width,
                      child: Center(
                        child: Text("WIP"),
                      ),
                    ),
                    CustomAppBar("Przypomnij hasło")
                  ],
                ),
              ),
            )
        )
    );
  }
}
