import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/InsideShopNavigationViews/Cart.dart';

class BookingViewResult extends StatefulWidget {
  final DateTime _chosenDate;
  final int _quarterIndex;
  final Function clearCart;

  BookingViewResult(this._chosenDate, this._quarterIndex, this.clearCart);

  @override
  _BookingViewResultState createState() => _BookingViewResultState();
}

class _BookingViewResultState extends State<BookingViewResult> {
  int calculateMinutes(int quarter){
    return (7 + (quarter / 4).floor()) * 60 + ((quarter % 4) * 15);
  }

  ScrollController _scrollController = ScrollController();

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
                  Container(
                    width: mediaSize.width,
                    height: mediaSize.height,
                    child: Column(
                      children: [
                        SizedBox(height: mediaSize.height * 0.1,),

                        Text("Tutaj będzie lista produktów z koszyka"),
                        Expanded(
                          child: Center(
                            child: Container(
                              width: mediaSize.width * 0.7,
                              height: mediaSize.height * 0.1,
                              child: Button("Zatwierdź rezerwację",
                                () async{
                                  await widget.clearCart();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomAppBar("Potwierdzenie",),
                ],
              ),
            ),
          )
      ),
    );
  }
}
