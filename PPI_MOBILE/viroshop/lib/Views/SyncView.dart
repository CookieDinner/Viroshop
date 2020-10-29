import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';

class SyncView extends StatefulWidget {
  @override
  _SyncViewState createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Synchronizacja", style: TextStyle(fontWeight: FontWeight.w400),),
            titleSpacing: mediaSize.width * 0.04,
            backgroundColor: Constants.appBarTheme,
          ),
          backgroundColor: Constants.background,
          body: Container(
            height: mediaSize.height,
            width: mediaSize.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/tempbg.png"),
                    fit: BoxFit.cover
                )
            ),
            child: Center(
              child: Text("WIP"),
            ),
          )
      )
    );
  }
}
