import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/CustomWidgets/ProductTemplate.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/NavigationViews/NavigationViewTemplate.dart';
import 'package:viroshop/Views/StoreNavigationView.dart';
import 'package:viroshop/World/Product.dart';

// ignore: must_be_immutable
class Products extends StatefulWidget implements NavigationViewTemplate{
  final StoreNavigationView parent;
  Products(this.parent);
  _ProductsState state = _ProductsState();
  @override
  _ProductsState createState() => state;

  @override
  Future<void> update() async{

    return null;
  }
}

class _ProductsState extends State<Products> {
  final ScrollController scrollController = ScrollController();

  String products;
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      String response = await Requests.GetProductsInShop(Data().currentShop.id);
      List<dynamic> list = jsonDecode(response);
      list.forEach((element) {
        filteredProducts.add(Product.fromJson(element));
      });
      setState(() {

      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
      color: CustomTheme().background,
      child: Stack(
        children: [
          BackgroundAnimation(),
          //TODO Lista produktów
          Container(
            child: Column(
              children: [
                SizedBox(height: mediaSize.height * 0.08,),
                CustomTextFormField(searchController, "Nazwa/Miasto", TextInputAction.done, (_){}, null),
                SizedBox(height: mediaSize.height * 0.02,),
                Expanded(
                  child: Scrollbar(
                    radius: Radius.circular(20),
                    thickness: 15,
                    isAlwaysShown: true,
                    controller: scrollController,
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: filteredProducts.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return ProductTemplate(filteredProducts[index], (){});
                        }
                    ),
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
