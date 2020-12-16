import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/World/Templates/ProductTemplate.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/InsideShopNavigationViewTemplate.dart';
import 'package:viroshop/Views/InsideShopNavigationView.dart';
import 'package:viroshop/World/Product.dart';

// ignore: must_be_immutable
class Products extends StatefulWidget implements InsideShopNavigationViewTemplate{
  final InsideShopNavigationView parent;
  Products(this.parent);

  _ProductsState state = _ProductsState();
  @override
  _ProductsState createState() => state;

  @override
  Future<void> update() async{

    return null;
  }

  Future<void> getProducts() async{
    state.products = await DbHandler.getProducts();
    state.filteredProducts = List.from(state.products);
    state.stateSet();
  }

}

class _ProductsState extends State<Products> {
  final ScrollController scrollController = ScrollController();

  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  StreamController<bool> streamController = StreamController<bool>();

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      widget.getProducts();
      streamController.add(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  void stateSet(){
    setState(() {
    });
  }

  void updateSearch(String text){
    filteredProducts = List.from(products);
    var split = text.split(" ");
    for (String textPart in split)
      filteredProducts.retainWhere((element)=>
      (element.name.toUpperCase().contains(textPart.toUpperCase())));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
      height: mediaSize.height,
      width: mediaSize.width,
      color: CustomTheme().background,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: BackgroundAnimation()
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: mediaSize.height * 0.08,),
                CustomTextFormField(searchController, "Nazwa produktu...",
                  TextInputAction.search, (_){}, null, trailingIcon: Icon(Icons.search),
                  onChangeAction: updateSearch,),
                SizedBox(height: mediaSize.height * 0.02,),
                Expanded(
                  child: StreamBuilder<Object>(
                    stream: streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return DraggableScrollbar.rrect(
                          alwaysVisibleScrollThumb: true,
                          backgroundColor: CustomTheme().accent,
                          heightScrollThumb: filteredProducts.length > 4 ?
                            max(mediaSize.height * 2 / filteredProducts.length,
                                mediaSize.height * 0.05) : 0,
                          padding: EdgeInsets.all(1),
                          controller: scrollController,
                          child: ListView.builder(
                              controller: scrollController,
                              itemCount: filteredProducts.length,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductTemplate(filteredProducts[index], (){});
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
          ),
          CustomAppBar("Lista produktów")
        ],
      ),
    );
  }
}
