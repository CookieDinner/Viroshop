import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';

import 'BookingViewResult.dart';

class BookingViewHours extends StatefulWidget {
  final DateTime _chosenDate;
  final Function clearCart;

  BookingViewHours(this._chosenDate, this.clearCart);

  @override
  _BookingViewHoursState createState() => _BookingViewHoursState();
}

class _BookingViewHoursState extends State<BookingViewHours> {

  bool compareHours(DateTime date1, DateTime date2){
    if(DateTime(date1.year, date1.month, date1.day).difference(DateTime(date2.year, date2.month, date2.day)).inDays > 0)
      return true;
    else
      return false;
  }
  void openResultsView(int quarterIndex){
    Navigator.of(context).push(
        CustomPageTransition(
          BookingViewResult(widget._chosenDate, quarterIndex, widget.clearCart),
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
                        Expanded(
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
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    child: Container(
                                      height: mediaSize.height * 0.07,
                                      width: mediaSize.width * 0.8,
                                      child: Button(
                                        (7 + (index / 4).floor()).toString()+":"+
                                            (((index % 4) * 15) == 0 ? "00" :
                                            ((index % 4) * 15).toString()),
                                        (){
                                          if(calculateMinutes(index) >
                                              (DateTime.now().hour * 60 + DateTime.now().minute) ||
                                              compareHours(widget._chosenDate, DateTime.now())){
                                            openResultsView(index);
                                          }
                                        },
                                        optionalColor: calculateMinutes(index) >
                                            (DateTime.now().hour * 60 + DateTime.now().minute)  ||
                                            compareHours(widget._chosenDate, DateTime.now())?
                                        CustomTheme().textBackground.withOpacity(0.5) :
                                        CustomTheme().textBackground.withOpacity(0.15),
                                        optionalTextColor: calculateMinutes(index) >
                                            (DateTime.now().hour * 60 + DateTime.now().minute)  ||
                                            compareHours(widget._chosenDate, DateTime.now())?
                                        Colors.black :
                                        Colors.black.withOpacity(0.15),
                                      )
                                    ),
                                  ),
                                );
                              }
                            ),
                          )
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
