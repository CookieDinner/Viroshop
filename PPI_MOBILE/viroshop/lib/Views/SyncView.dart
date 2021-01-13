import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/MainMenuView.dart';

class SyncView extends StatefulWidget {
  @override
  _SyncViewState createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {

  List<String> downloadElements = [
    "Sklepów"
  ];
  var currentElement = "";
  var progressPercentage = 0.0;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      setState(() {
        currentElement = downloadElements[0];
      });
      await Future.delayed(Duration(milliseconds: 500));
      String response = await commenceDownload();
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context).pushReplacement(
          CustomPageTransition(
            MainMenuView(response),
            x: 0.0,
            y: 0.0,
          )
        );
      });
  }

  Future<String> commenceDownload() async{

      String shops = await Requests.GetShops();
      for (var j = 0; j < 10; j++) {
        setState(() {
          progressPercentage+= 1 / (downloadElements.length*10);
        });
        if (j < 9)
          await Future.delayed(Duration(milliseconds: 30), (){});
      }
      return shops;

    // setState(() {
    //   currentElement = downloadElements[0];
    // });
    //
    // for (var i = downloadElements.length; i < downloadElements.length * 2; i++){
    //   await Future.delayed(Duration(milliseconds: 50), (){});
    //   for (var j = 0; j < 10; j++) {
    //     setState(() {
    //       progressPercentage += 1 / (downloadElements.length*20);
    //     });
    //     if (j < 9)
    //       await Future.delayed(Duration(milliseconds: 30), (){});
    //   }
    //   setState(() {
    //     if (i + 1 - downloadElements.length < downloadElements.length)
    //       currentElement = downloadElements[i+1-downloadElements.length];
    //   });
    // }
    //return true;
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Trwa \"pobieranie\":",
                            style: TextStyle(
                              color: CustomTheme().accentText,
                              fontSize: mediaSize.width * Constants.appBarFontSize
                            ),
                          ),
                          Text(
                            currentElement,
                            style: TextStyle(
                              color: CustomTheme().accentText,
                              fontSize: mediaSize.width * Constants.appBarFontSize
                            ),
                          ),
                          SizedBox(height: mediaSize.height * 0.03,),
                          Container(
                            width: mediaSize.width * 0.7,
                            child: LinearProgressIndicator(
                              value: progressPercentage,
                              valueColor: AlwaysStoppedAnimation<Color>(CustomTheme().buttonColor),
                              backgroundColor: CustomTheme().cardColor,
                              minHeight: mediaSize.height * 0.04,
                            ),
                          )
                        ],
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
