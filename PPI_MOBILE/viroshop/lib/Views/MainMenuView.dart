import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/StoreTemplate.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Store.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  final ScrollController scrollController = ScrollController();

  List<Store> filteredStores = [Store("Biedronka"), Store("Żabka"),Store("dasd"), Store("nanana"),Store("sklepik"), Store("a")];

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: CustomTheme().background,
          body: Container(
            height: mediaSize.height,
            width: mediaSize.width,
            child: Stack(
              children: [
                BackgroundAnimation(),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: mediaSize.height * 0.1,),
                      Expanded(
                        child: Scrollbar(
                          radius: Radius.circular(20),
                          thickness: 15,
                          isAlwaysShown: true,
                          controller: scrollController,
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: filteredStores.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return StoreTemplate(filteredStores[index]);
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomAppBar("Sklepy"),
              ],
            ),
          )
      ),
    );
  }
}
