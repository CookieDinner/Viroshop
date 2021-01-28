import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/CartActions/BookingViewDate.dart';
import 'package:viroshop/Views/CartActions/BookingViewResult.dart';
import 'package:viroshop/Views/ZbikPayment/ZbikPaymentView.dart';
import 'package:viroshop/World/CartItem.dart';

class BookOrOrder extends StatefulWidget {
  final Function clearCart;
  final List<CartItem> cartItems;

  BookOrOrder(this.clearCart, this.cartItems);

  @override
  _BookOrOrderState createState() => _BookOrOrderState();
}

int getFutureReservationsCount(String body){
  List<bool> counts = [];
  List<dynamic> tests = jsonDecode(body);
  for (Map<String, dynamic> test in tests){
    int quarter = test['quarterOfDay'];
    if (test['date'] != null) {
      DateTime time = DateTime.parse(test['date']);
      time.add(Duration(hours: 7 + quarter ~/ 4, minutes: quarter * 15));
      int millis = (((7 + quarter ~/4 ) * 60) +  (quarter % 4 * 15)) * 60 * 1000;
      int totalMillis = time.millisecondsSinceEpoch + millis;
      if(DateTime.now().millisecondsSinceEpoch < totalMillis)
        counts.add(true);
    }
  }
  return counts.length;
}

class _BookOrOrderState extends State<BookOrOrder> {

  void openZbikView(){
    Navigator.of(context).push(
        CustomPageTransition(
          ZbikPaymentView(widget.clearCart),
          x: 0.0,
          y: -0.1,
        )
    );
  }
  void openBookingView() async{
    int count = getFutureReservationsCount(await Requests.getShopReservations());
    if (count < 2) {
      Navigator.of(context).push(
        CustomPageTransition(
          BookingViewDate(widget.clearCart, widget.cartItems),
          x: 0.0,
          y: 0.1,
        )
      );
    }else{
      CustomAlerts.showAlertDialog(context, "Błąd", "Nie można złożyć więcej niż 2. przyszłych rezerwacji w jednym sklepie.");
    }
  }

  void openResultsView(){
    Navigator.of(context).push(
        CustomPageTransition(
          BookingViewResult(null, 0, widget.clearCart, widget.cartItems, pops: 4,),
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
                          child: Button("Zaplanuj wizytę bez dnia i godziny", openResultsView)
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

