import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'dart:convert';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/CartActions/BookingViewHours.dart';
import 'package:viroshop/World/CartItem.dart';

class BookingViewDate extends StatefulWidget {

  final Function clearCart;
  final List<CartItem> cartItems;

  BookingViewDate(this.clearCart, this.cartItems);

  @override
  _BookingViewDateState createState() => _BookingViewDateState();
}

class MonthCount{
  final DateTime date;
  final int count;
  MonthCount(this.date, this.count);
}
class _BookingViewDateState extends State<BookingViewDate> {

  bool hasChosenOnce = false;
  int lastMonth = 0;


  Color buttonColor = Colors.grey.withOpacity(0.5);
  Color textColor = Colors.black.withOpacity(0.5);
  List<MonthCount> monthCounts = [];

  bool compareDates(DateTime date1, DateTime date2){
    if(DateTime(date1.year, date1.month, date1.day).difference(DateTime(date2.year, date2.month, date2.day)).inDays >= 0)
      return true;
    else
      return false;
  }

  void openHoursView(){
    if(hasChosenOnce)
      Navigator.of(context).push(
          CustomPageTransition(
            BookingViewHours(_currentDate, widget.clearCart, widget.cartItems),
            x: 0.0,
            y: 0.1,
          )
      );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List<dynamic> counts = jsonDecode(await Requests.getMonthCounts(DateTime.now()));
      for (Map<String, dynamic> count in counts)
        monthCounts.add(MonthCount(DateTime.parse(count["date"]), count["count"]));
      lastMonth = DateTime.now().month;
      setState(() {});
    });

    super.initState();
  }

  DateTime _currentDate;
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CalendarCarousel(
                            onDayPressed: (DateTime date, List events){
                              hasChosenOnce = true;
                              buttonColor = CustomTheme().buttonColor;
                              textColor = Colors.white;
                              if(compareDates(date, DateTime.now()) && date.month == lastMonth)
                                this.setState(() {
                                  _currentDate = date;
                                });
                            },
                            onCalendarChanged: (DateTime time) async{
                              hasChosenOnce = false;
                              buttonColor = Colors.grey.withOpacity(0.5);
                              textColor = Colors.black.withOpacity(0.5);
                              if (lastMonth != time.month) {
                                lastMonth = time.month;
                                monthCounts.clear();
                                List<dynamic> counts = jsonDecode(await Requests.getMonthCounts(time));
                                for (Map<String, dynamic> count in counts)
                                  monthCounts.add(MonthCount(DateTime.parse(count["date"]), count["count"]));
                                setState(() {});
                              }
                            },
                            customDayBuilder: (
                              bool isSelectable,
                              int index,
                              bool isSelectedDay,
                              bool isToday,
                              bool isPrevMonthDay,
                              TextStyle textStyle,
                              bool isNextMonthDay,
                              bool isThisMonthDay,
                              DateTime day,
                            ){
                              if(compareDates(day, DateTime.now())) {
                                if (!isPrevMonthDay && !isNextMonthDay) {
                                    Iterable<MonthCount> currentCounts = monthCounts.where((element) => element.date.day == day.day);
                                    if (currentCounts.isEmpty || currentCounts.first.count < 10) {
                                      return Container(
                                        height: 300,
                                        width: 300,
                                        color: Colors.green
                                            .withOpacity(0.8),
                                        child: Center(child: Text(
                                          day.day.toString(),
                                          style: TextStyle(),)),
                                      );
                                    }else {
                                      int count = currentCounts.first.count;
                                      if (count < 20) {
                                        return Container(
                                          height: 300,
                                          width: 300,
                                          color: Colors.yellow
                                              .withOpacity(0.8),
                                          child: Center(child: Text(
                                            day.day.toString(),
                                            style: TextStyle(),)),
                                        );
                                      } else if (count >= 20 && count < 30){
                                        return Container(
                                          height: 300,
                                          width: 300,
                                          color: Colors.orange
                                              .withOpacity(0.8),
                                          child: Center(child: Text(
                                            day.day.toString(),
                                            style: TextStyle(),)),
                                        );
                                      }else{
                                        return Container(
                                          height: 300,
                                          width: 300,
                                          color: Colors.redAccent
                                              .withOpacity(0.8),
                                          child: Center(child: Text(
                                            day.day.toString(),
                                            style: TextStyle(),)),
                                        );
                                      }
                                    }
                                }
                                else {
                                  return Container(
                                    height: 300,
                                    width: 300,
                                    color: Colors.transparent,
                                    child: Center(),
                                  );
                                }
                              }
                              else {
                                return Container(
                                  height: 300,
                                  width: 300,
                                  color: CustomTheme().textBackground
                                      .withOpacity(0.18),
                                  child: Center(child: Text(day.day.toString(),
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(
                                            0.15)),)),
                                );
                              }
                            },
                            weekDayBackgroundColor: CustomTheme().textBackground.withOpacity(0.35),
                            weekFormat: false,
                            height: mediaSize.height * 0.59,
                            selectedDateTime: _currentDate,
                            daysHaveCircularBorder: false,
                            todayBorderColor: Colors.red,
                            todayButtonColor: Colors.red.withOpacity(0.2),
                            selectedDayBorderColor: CustomTheme().accentPlus,
                            selectedDayButtonColor: CustomTheme().accentPlus.withOpacity(0.2),
                            locale: "pl",
                            thisMonthDayBorderColor: Colors.black.withOpacity(0.1),
                            prevMonthDayBorderColor: Colors.grey.withOpacity(0.1),
                            nextMonthDayBorderColor: Colors.grey.withOpacity(0.1),
                            weekdayTextStyle: TextStyle(color: CustomTheme().accentPlus),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                                width: mediaSize.width * 0.7,
                                height: mediaSize.height * 0.1,
                                child: Button("Wybierz godzinę", openHoursView, optionalColor: buttonColor, optionalTextColor: textColor,)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomAppBar("Wybór daty rezerwacji"),
                ],
              ),
            ),
          )
      ),
    );
  }
}
