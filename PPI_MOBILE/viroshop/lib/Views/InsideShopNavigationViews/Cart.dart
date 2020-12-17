import 'dart:async';
import 'dart:math';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/InsideShopNavigationViewTemplate.dart';
import 'package:viroshop/Views/InsideShopNavigationView.dart';
import 'package:viroshop/World/CartItem.dart';
import 'package:viroshop/World/Product.dart';
import 'package:viroshop/World/Templates/CartItemTemplate.dart';

import '../ZbikPayment/ZbikPaymentView.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget implements InsideShopNavigationViewTemplate {
  final InsideShopNavigationView parent;

  Cart(this.parent);

  _CartState state = _CartState();

  @override
  _CartState createState() => state;


  @override
  Future<void> update() async{
    state.cartItems = await DbHandler.getCart(Data().currentShop);
    state.fullPrice = 0.0;
    state.cartItems.forEach((element) {
      state.fullPrice += element.quantity * element.cartProduct.price;
    });
    state.stateSet();
    state.streamController.add(true);
    return null;
  }
}

class _CartState extends State<Cart> {
  List<CartItem> cartItems = [];
  StreamController<bool> streamController = StreamController<bool>();
  ScrollController scrollController = ScrollController();
  double fullPrice = 0.0;
  bool isCurrentlyProcessing = false;

  void openPaymentScreen() {
    Navigator.of(context).push(
        CustomPageTransition(
          ZbikPaymentView(),
          x: 0.0,
          y: 0.5,
        )
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    scrollController.dispose();
    super.dispose();
  }

  void stateSet(){
    setState(() {});
  }

  Future<void> addToCart(Product productToAdd, int quantity) async{
    if (isCurrentlyProcessing)
      return false;
    else {
      setState(() {isCurrentlyProcessing = true;});
      await DbHandler.insertToCart(Data().currentShop, productToAdd, quantity);
      setState(() {isCurrentlyProcessing = false;});
    }
  }

  Future<void> deleteFromCart(CartItem cartItem, int quantity) async{
    if (isCurrentlyProcessing)
      return false;
    else {
      setState(() {isCurrentlyProcessing = true;});
      await DbHandler.deleteFromCart(Data().currentShop, cartItem, quantity);
      widget.update();
      setState(() {isCurrentlyProcessing = false;});
    }
  }

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
          //TODO Koszyk
          Container(
            child: Column(
              children: [
                CustomAppBar(
                  "Koszyk",
                  withOptionButton: true,
                  optionButtonWidget: Text(
                    "Zamów",
                    style: TextStyle(
                      fontSize:
                          mediaSize.width * Constants.appBarFontSize * 0.9,
                      fontWeight: FontWeight.w400,
                      color: CustomTheme().appBarTheme,
                    ),
                  ),
                  optionButtonAction: openPaymentScreen,
                  isTextOptionButton: true,
                ),
                Container(
                  height: mediaSize.height * 0.7,
                  child: StreamBuilder<Object>(
                      stream: streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return DraggableScrollbar.rrect(
                            alwaysVisibleScrollThumb: true,
                            backgroundColor: CustomTheme().accent,
                            heightScrollThumb: cartItems.length > 6 ?
                            max(mediaSize.height * 2 / cartItems.length,
                                mediaSize.height * 0.05) : 0,
                            padding: EdgeInsets.all(1),
                            controller: scrollController,
                            child: ListView.builder(
                                controller: scrollController,
                                itemCount: cartItems.length,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      SizedBox(height: mediaSize.height * 0.008,),
                                      Slidable(
                                        key: UniqueKey(),
                                        actionPane: SlidableDrawerActionPane(),
                                        dismissal: SlidableDismissal(
                                          resizeDuration: Duration(milliseconds: 400),
                                          child: SlidableDrawerDismissal(),
                                          onDismissed: (actionType){
                                            deleteFromCart(cartItems[index], 0);
                                          },
                                        ),
                                        secondaryActions: [
                                          IconSlideAction(
                                            color: Colors.red.withOpacity(0.5),
                                            icon: Icons.delete_forever,
                                            onTap: () => deleteFromCart(cartItems[index], 0),
                                          )
                                        ],
                                        child: CartItemTemplate(cartItems[index], deleteFromCart)
                                      ),
                                      SizedBox(height: mediaSize.height * 0.008,),
                                    ],
                                  );
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
                Expanded(
                  child: Center(
                    child: Text(
                      "Cena całego koszyka: " + fullPrice.toStringAsFixed(2) + " zł",
                      style: TextStyle(
                        fontSize: mediaSize.width * Constants.appBarFontSize,
                        color: CustomTheme().appBarTheme,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
