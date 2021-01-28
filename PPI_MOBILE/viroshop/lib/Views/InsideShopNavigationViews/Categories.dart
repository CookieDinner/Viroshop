import 'dart:async';
import 'dart:math';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/InsideShopNavigationViewTemplate.dart';
import 'package:viroshop/Views/InsideShopNavigationView.dart';
import 'package:viroshop/World/Templates/CategoryTemplate.dart';

// ignore: must_be_immutable
class Categories extends StatefulWidget implements InsideShopNavigationViewTemplate{
  final InsideShopNavigationView parent;
  final Function function;
  Categories(this.parent, this.function);

  _CategoriesState state = _CategoriesState();
  @override
  _CategoriesState createState() => state;

  @override
  Future<void> update() {
    getCategories();
    state.streamController.add(true);
    return null;
  }

  Future<void> getCategories() async{
    state.categories = await DbHandler.getCategories();
    state.categories.sort((a, b) => a.compareTo(b));
    state.stateSet();
  }
}

class _CategoriesState extends State<Categories> {

  StreamController<bool> streamController = StreamController<bool>();
  ScrollController scrollController = ScrollController();
  bool isCurrentlyProcessing = false;

  void stateSet(){
    setState(() {
    });
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  List<String> categories = [];
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
      color: CustomTheme().background,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: BackgroundAnimation()
          ),
          Column(
            children: [
              SizedBox(height: mediaSize.height * 0.07,),
              Expanded(
                child: StreamBuilder<Object>(
                    stream: streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return DraggableScrollbar.rrect(
                          alwaysVisibleScrollThumb: true,
                          backgroundColor: CustomTheme().accent,
                          heightScrollThumb: categories.length > 10 ?
                          max(mediaSize.height * 2 / categories.length,
                              mediaSize.height * 0.05) : 0,
                          controller: scrollController,
                          child: GridView.builder(
                              controller: scrollController,
                              itemCount: categories.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: mediaSize.width * 0.05,
                                vertical: mediaSize.height * 0.02,
                              ),
                              physics: AlwaysScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: mediaSize.height * 0.03,
                                  crossAxisSpacing: mediaSize.height * 0.03,
                                  childAspectRatio: 7 / 5,),
                              itemBuilder: (BuildContext context, int index) {
                                return CategoryTemplate(categories[index], widget.function);
                              }
                          ),
                        );
                      else
                        return SpinKitFadingCube(
                          color: CustomTheme().buttonColor,
                          size: MediaQuery.of(context).size.width * 0.1,
                        );
                    }
                ),
              ),
            ],
          ),
          Container(
            child: Column(
              children: [
                CustomAppBar("Kategorie")
              ],
            ),
          )
        ],
      ),
    );
  }
}
