import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/CartActions/BookingViewDate.dart';
import 'package:viroshop/Views/ZbikPayment/ZbikPaymentView.dart';
import 'package:viroshop/World/CartItem.dart';

class BookOrOrder extends StatefulWidget {
  final Function clearCart;
  final List<CartItem> cartItems;

  BookOrOrder(this.clearCart, this.cartItems);

  @override
  _BookOrOrderState createState() => _BookOrOrderState();
}

class _BookOrOrderState extends State<BookOrOrder> {

  void openZbikView(){
    Navigator.of(context).push(
        CustomPageTransition(
          ZbikPaymentView(),
          x: 0.0,
          y: -0.1,
        )
    );
  }
  void openBookingView(){
    Navigator.of(context).push(
        CustomPageTransition(
          BookingViewDate(widget.clearCart, widget.cartItems),
          x: 0.0,
          y: 0.1,
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme().background,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: mediaSize.height,
            width: mediaSize.width,
            child: Stack(
              children: [
                BackgroundAnimation(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: mediaSize.width * 0.7,
                        height: mediaSize.height * 0.1,
                        child: Button("Rezerwacja wizyty w sklepie", openBookingView)
                      ),
                      SizedBox(height: mediaSize.height * 0.05,),
                      Container(
                          width: mediaSize.width * 0.7,
                          height: mediaSize.height * 0.1,
                          child: Button("\"Zarezerwuj\" wizytę bez dnia i godziny", (){})
                      ),
                      SizedBox(height: mediaSize.height * 0.05,),
                      Container(
                          width: mediaSize.width * 0.7,
                          height: mediaSize.height * 0.1,
                          child: Button("Zamówienie do sklepomatu", openZbikView)
                      ),
                    ],
                  ),
                ),
                CustomAppBar("Wybór operacji"),
              ],
            ),
          ),
        )
      ),
    );
  }
}

