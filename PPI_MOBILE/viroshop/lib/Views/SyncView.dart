import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/MainMenuView.dart';

class SyncView extends StatefulWidget {
  @override
  _SyncViewState createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Future.delayed(Duration(seconds: 2), (){
                Navigator.of(context).pushReplacement(
                    CustomPageTransition(
                      MainMenuView(),
                      x: 0.0,
                      y: 0.0,
                    )
                );
              });
      });
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = Util.getDimensions(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
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
                        child: Text("Tutaj będzie ładowanie SQLów",
                          style: TextStyle(color: CustomTheme().standardText),),
                      ),
                    ),
                    CustomAppBar("Synchronizacja", withBackButton: false)
                  ],
                ),
              ),
            )
        )
      ),
    );
  }
}
