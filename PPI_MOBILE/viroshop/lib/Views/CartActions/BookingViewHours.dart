import 'dart:async';
import 'dart:convert';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/CartItem.dart';

import 'BookingViewResult.dart';

class BookingViewHours extends StatefulWidget {
  final DateTime _chosenDate;
  final Function clearCart;
  final List<CartItem> cartItems;

  BookingViewHours(this._chosenDate, this.clearCart, this.cartItems);

  @override
  _BookingViewHoursState createState() => _BookingViewHoursState();
}

class DayCount{
  final int quarter;
  final int count;
  DayCount(this.quarter, this.count);
}

class _BookingViewHoursState extends State<BookingViewHours> {

  StreamController<bool> streamController = StreamController<bool>();
  List<DayCount> dayCounts = [];

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List<dynamic> counts = jsonDecode(await Requests.getDayCounts(widget._chosenDate));
      for (Map<String, dynamic> count in counts)
        dayCounts.add(DayCount(count["quarter"], count["count"]));
      streamController.add(true);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose(){
    streamController.close();
    super.dispose();
  }

  bool compareHours(DateTime date1, DateTime date2){
    if(DateTime(date1.year, date1.month, date1.day).difference(DateTime(date2.year, date2.month, date2.day)).inDays > 0)
      return true;
    else
      return false;
  }
  void openResultsView(int quarterIndex){
    Navigator.of(context).push(
        CustomPageTransition(
          BookingViewResult(widget._chosenDate, quarterIndex, widget.clearCart, widget.cartItems, pops: 6,),
          x: 0.0,
          y: 0.1,
        )
    );
  }

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
                        StreamBuilder<Object>(
                          stream: streamController.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Expanded(
                                  child: DraggableScrollbar.rrect(
                                    alwaysVisibleScrollThumb: true,
                                    backgroundColor: CustomTheme().accent,
                                    heightScrollThumb: mediaSize.height / 8,
                                    padding: EdgeInsets.all(1),
                                    controller: _scrollController,
                                    child: ListView.builder(
                                        controller: _scrollController,
                                        itemCount: 64,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int index) {
                                          int currentCount = dayCounts.firstWhere((element) => element.quarter == index).count;
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Align(
                                              child: Container(
                                                  height: mediaSize.height * 0.07,
                                                  width: mediaSize.width * 0.8,
                                                  child: Button(
                                                    (7 + (index / 4).floor())
                                                        .toString() + ":" +
                                                        (((index % 4) * 15) == 0 ? "00" :
                                                        ((index % 4) * 15).toString()),
                                                        () {
                                                      if (calculateMinutes(index) > (DateTime.now().hour * 60 + DateTime.now().minute) || compareHours(widget._chosenDate, DateTime.now())) {
                                                        if (currentCount != Data().currentShop.maxReservationsPerQuarterOfHour)
                                                          openResultsView(index);
                                                        else
                                                          CustomAlerts.showAlertDialog(context, "Błąd", "Nie można zarezerwować wizyty na tą godzinę ze względu na istniejącą maksymalną liczbę rezerwacji w tym oknie czasowym.");
                                                      }
                                                    },
                                                    optionalColor: calculateMinutes(index) > (DateTime.now().hour * 60 + DateTime.now().minute) || compareHours(widget._chosenDate, DateTime.now()) ?
                                                    (currentCount == 0 ? Colors.green :
                                                    currentCount <= Data().currentShop.maxReservationsPerQuarterOfHour * 0.2 ? Colors.lightGreenAccent :
                                                    currentCount <= Data().currentShop.maxReservationsPerQuarterOfHour * 0.4 ? Colors.yellowAccent :
                                                    currentCount <= Data().currentShop.maxReservationsPerQuarterOfHour * 0.6 ? Colors.orangeAccent :
                                                    currentCount <= Data().currentShop.maxReservationsPerQuarterOfHour * 0.8 ? Colors.deepOrangeAccent :
                                                    currentCount > Data().currentShop.maxReservationsPerQuarterOfHour * 0.8 &&
                                                        currentCount < Data().currentShop.maxReservationsPerQuarterOfHour ? Colors.deepOrange :
                                                    Colors.red) :
                                                    CustomTheme().textBackground.withOpacity(0.15),
                                                    optionalTextColor: calculateMinutes(index) > (DateTime.now().hour * 60 + DateTime.now().minute) || compareHours(widget._chosenDate, DateTime.now()) ?
                                                    Colors.black : Colors.black.withOpacity(0.15),
                                                  )
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                  )
                              );
                            }else{
                              return Expanded(
                                child: Center(
                                  child: SpinKitFadingCube(
                                    color: CustomTheme().buttonColor,
                                    size: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ),
                              );
                            }
                          }
                        )
                      ],
                    ),
                  ),
                  CustomAppBar("Wybór godziny rezerwacji"),
                ],
              ),
            ),
          )
      ),
    );
  }
}
