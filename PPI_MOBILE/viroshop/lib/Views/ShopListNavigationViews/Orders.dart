import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/OrderView.dart';
import 'package:viroshop/Views/ShopListNavigationView.dart';
import 'package:viroshop/Views/ShopListNavigationViewTemplate.dart';
import 'package:viroshop/World/Order.dart';
import 'package:viroshop/World/Product.dart';
import 'package:viroshop/World/Shop.dart';
import 'package:viroshop/World/Templates/OrderTemplate.dart';

class Orders extends StatefulWidget implements ShopListNavigationViewTemplate{
  final ShopListNavigationView parent;
  final Function openDrawer;
  Orders(this.parent, this.openDrawer);

  List<Shop> favoriteShops = [];

  _OrdersState ordersState = _OrdersState();
  @override
  _OrdersState createState() => ordersState;

  @override
  Future<void> update() {
    ordersState.stateSet();
    return null;
  }
}

class _OrdersState extends State<Orders> {

  StreamController<bool> streamController = StreamController<bool>();
  ScrollController scrollController = ScrollController();

  List<Order> orders = [];
  void stateSet(){
    setState(() {
    });
  }

  @override
  void initState() {
    //orders.add(Order(1, [], DateTime.now(), Shop(1, "dsa", "dsad", 4, "Biedronka"), 5));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      String response = await Requests.getReservations();
      List<dynamic> ordersTemp = jsonDecode(response);
      for(Map<String, dynamic> singleOrderTemp in ordersTemp){
        Map<String, dynamic> tempShop = jsonDecode(await Requests.getShopById(singleOrderTemp["shop"]));
        List<Product> tempProducts = [];
        for(Map<String, dynamic> singleProduct in singleOrderTemp["productReservations"]){
          Map<String, dynamic> tempProduct = jsonDecode(await Requests.getProductById(singleProduct["product"]));
          tempProducts.add(Product(
              tempProduct["id"],
              tempProduct["name"],
              tempProduct["category"],
              tempProduct["available"],
              tempProduct["price"]));
        }
        orders.add(
            Order(
                singleOrderTemp["id"],
                tempProducts,
                DateTime.parse(singleOrderTemp["date"]),
                Shop(tempShop["id"], tempShop["city"], tempShop["street"], tempShop["number"], tempShop["name"]),
                singleOrderTemp["quarterOfDay"]
            )
        );
      }
      streamController.add(true);
    });
    super.initState();
  }
  @override
  void dispose() {
    streamController.close();
    super.dispose();
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
            height: mediaSize.height,
            width: mediaSize.width,
            child: Column(
              children: [
                SizedBox(height: mediaSize.height * 0.08,),
                Container(
                  height: mediaSize.height * 0.78,
                  child: StreamBuilder<Object>(
                      stream: streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return DraggableScrollbar.rrect(
                            alwaysVisibleScrollThumb: true,
                            backgroundColor: CustomTheme().accent,
                            heightScrollThumb: orders.length > 5 ?
                            max(mediaSize.height * 2 / orders.length,
                                mediaSize.height * 0.05) : 0,
                            padding: EdgeInsets.all(1),
                            controller: scrollController,
                            child: ListView.builder(
                                controller: scrollController,
                                itemCount: orders.length,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return OrderTemplate(orders[index],
                                  (Order currentOrder){
                                    Navigator.of(context).push(
                                        CustomPageTransition(
                                          OrderView(currentOrder),
                                          x: 0.0,
                                          y: 0.1,
                                        )
                                    );
                                  });
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
          CustomAppBar("Rezerwacje",
            withOptionButton: true,
            optionButtonAction: widget.openDrawer,
            optionButtonWidget: Icon(
              Icons.settings,
              size: mediaSize.width * 0.07,
              color: CustomTheme().accentPlus,
            ),
          ),
        ],
      ),
    );
  }
}
