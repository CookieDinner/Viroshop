import 'dart:async';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/CartItem.dart';
import 'package:viroshop/World/Templates/CartItemTemplate.dart';

class BookingViewResult extends StatefulWidget {
  final DateTime _chosenDate;
  final int _quarterIndex;
  final Function clearCart;
  final List<CartItem> cartItems;
  final int pops;

  BookingViewResult(this._chosenDate, this._quarterIndex, this.clearCart, this.cartItems, {this.pops = 3});

  @override
  _BookingViewResultState createState() => _BookingViewResultState();
}

class _BookingViewResultState extends State<BookingViewResult> {
  int calculateMinutes(int quarter){
    return (7 + (quarter / 4).floor()) * 60 + ((quarter % 4) * 15);
  }

  Future<void> sendReservation() async {
    await Requests.PostReservation(Data().currentShop.id, widget._chosenDate, widget._quarterIndex, widget.cartItems);
    widget.clearCart(true, true);
  }

  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
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
                  Container(
                    width: mediaSize.width,
                    height: mediaSize.height,
                    child: Column(
                      children: [
                        SizedBox(height: mediaSize.height * 0.1,),
                        widget._chosenDate != null ? Row(
                          children: [
                            SizedBox(width: mediaSize.width * 0.05,),
                            Container(
                              child: Text("Data rezerwacji:",
                                style: TextStyle(
                                  color: CustomTheme().accentText,
                                  fontSize: mediaSize.width * Constants.appBarFontSize
                                ),
                              )
                            ),
                            SizedBox(width: mediaSize.width * 0.05,),
                            Container(
                                child: Text(DateFormat("dd-MM-yyyy").format(widget._chosenDate)+
                                    " " + (7 + (widget._quarterIndex / 4).floor()).toString()+":"+
                                        (((widget._quarterIndex % 4) * 15) == 0 ? "00" :
                                        ((widget._quarterIndex % 4) * 15).toString()),
                                  style: TextStyle(
                                      color: CustomTheme().standardText,
                                      fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                                  ),
                                )
                            ),
                          ],
                        ) : Container(),
                        SizedBox(height: mediaSize.height * 0.02,),
                        Row(
                          children: [
                            SizedBox(width: mediaSize.width * 0.05,),
                            Container(
                                child: Text("Sklep:",
                                  style: TextStyle(
                                      color: CustomTheme().accentText,
                                      fontSize: mediaSize.width * Constants.appBarFontSize
                                  ),
                                )
                            ),
                            SizedBox(width: mediaSize.width * 0.05,),
                            Container(
                              width: mediaSize.width * 0.7,
                              child: Text("${Data().currentShop.name}, ul.${Data().currentShop.street}, ${Data().currentShop.city}",
                                softWrap: true,
                                style: TextStyle(
                                    color: CustomTheme().standardText,
                                    fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                                ),
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: mediaSize.height * 0.02,),
                        Container(
                            height: mediaSize.height * 0.5,
                            width: mediaSize.width,
                            child: DraggableScrollbar.rrect(
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: CustomTheme().accent,
                              heightScrollThumb: widget.cartItems.length > 4 ?
                                  mediaSize.height * 2 / widget.cartItems.length : 0,
                              padding: EdgeInsets.all(1),
                              controller: _scrollController,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: widget.cartItems.length,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: mediaSize.height * 0.01),
                                      child: CartItemTemplate(widget.cartItems[index], null),
                                    );
                                  }
                              ),
                            )
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              width: mediaSize.width * 0.7,
                              height: mediaSize.height * 0.1,
                              child: Button("Zatwierdź rezerwację",
                                () async{
                                  await sendReservation();
                                  for (int i = 0; i < widget.pops; i++)
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
