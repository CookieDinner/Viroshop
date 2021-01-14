import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Alley.dart';
import 'package:viroshop/World/Order.dart';
import 'package:viroshop/World/Product.dart';


class OrderView extends StatefulWidget {

  final Order currentOrder;

  OrderView(this.currentOrder,);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {

  TransformationController transformationController = TransformationController();
  // List<BlockTypes> alleys;
  List<Alley> alleysList = [];
  int columnsCount;
  double blocSize;
  int clickedIndex;
  Offset clickOffset;
  bool hasSizes = false;
  double outerPadding;
  StreamController<bool> streamController = StreamController<bool>();
  int allCount = 0;
  int crossAxisCount = 0;

  List<Product> makeProductsList(List<dynamic> products) {
    List<Product> productsList = [];
    for(Map<String, dynamic> product in products)
      productsList.add(Product(product["id"], product["name"], product["category"], 1, 0));
    return productsList;
  }
  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> updateSize(Alley alley) async{
    setState(() {
      allCount = alley.id;
      crossAxisCount = alley.xposition;
      print(alley.id.toString() + "   " + alley.xposition.toString());
    });
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
         String alleysJson = await Requests.GetAlleys(widget.currentOrder.shop.id);
        for(Map<String, dynamic> alley in jsonDecode(alleysJson))
          alleysList.add(
              Alley(
                  alley["id"],
                  alley["xposition"],
                  alley["yposition"],
                  alley["type"],
                  makeProductsList(alley["products"]),
                  alley["shopId"]
              )
          );
      await updateSize(alleysList.last);
      await _afterLayout(_);
      // setState(() {
      //   alleys = List<BlockTypes>.generate(allCount, (index) {
      //     return BlockTypes.gray;
      //   });
      // });
      streamController.add(true);
    });
    super.initState();
  }

  Future<void> _afterLayout(_) async{
    blocSize = context.size.width * 0.9 / crossAxisCount;
    columnsCount = (allCount / crossAxisCount).ceil();
    setState(() {
      hasSizes = true;
    });
  }

  void onTapDown(TapDownDetails details) {
    final RenderBox box = context.findRenderObject();
    clickOffset = box.globalToLocal(details.globalPosition);
  }

  void onTap() {
    final dx = clickOffset.dx - (context.size.width * 0.043);
    final dy = clickOffset.dy - (context.size.height * 0.073) - outerPadding;
    final tapedRow = (dx / blocSize).floor();
    final tapedColumn = (dy / blocSize).floor();
    if (tapedRow > -1 && tapedRow < crossAxisCount && tapedColumn > - 1 && tapedColumn < (allCount / crossAxisCount).ceil()) {
      clickedIndex = tapedColumn * crossAxisCount + tapedRow;
      // setState(() {
      //   alleysList[clickedIndex].type = "CLICKED";
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    outerPadding = MediaQuery.of(context).padding.top;
    return SafeArea(
        child: Scaffold(
          backgroundColor: CustomTheme().background,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: mediaSize.height,
              width: mediaSize.width,
              child: Stack(
                  children : <Widget> [
                    BackgroundAnimation(),
                    Container(
                      height: mediaSize.height,
                      width: mediaSize.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: mediaSize.height * 0.079,),
                          StreamBuilder<Object>(
                            stream: streamController.stream ,
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                return Container(
                                  color: CustomTheme().mapBg,
                                  width: mediaSize.width * 0.9,
                                  height: mediaSize.width * 0.9,
                                  child: GestureDetector(
                                    onTapDown: onTapDown,
                                    onTap: onTap,
                                    child: CustomPaint(
                                      painter: CustomGridView(
                                        alleys: alleysList,
                                        columnsCount: columnsCount,
                                        blocSize: blocSize,
                                        allCount: allCount,
                                        crossAxisCount: crossAxisCount
                                      ),
                                    ),
                                  ),
                                );
                              }else
                                return Container(
                                  width: mediaSize.width * 0.9,
                                  height: mediaSize.width * 0.9,
                                  child: Center(
                                    child: SpinKitFadingCube(
                                      color: CustomTheme().buttonColor,
                                      size: MediaQuery.of(context).size.width * 0.1,
                                    ),
                                  ),
                                );
                            }
                          )
                        ],
                      ),
                    ),
                    CustomAppBar("Rezerwacja ${widget.currentOrder.shop.name}"),
                  ]
              ),
            ),
          ),
        )
    );
  }
}

class CustomGridView extends CustomPainter {
  final double gap = 1;
  final Paint painter = Paint()
    ..strokeWidth = 1
    ..style = PaintingStyle.fill;

  final int columnsCount;
  final double blocSize;
  final List<Alley> alleys;
  final int allCount;
  final int crossAxisCount;

  CustomGridView({this.columnsCount, this.blocSize, this.alleys, this.allCount, this.crossAxisCount});

  @override
  void paint(Canvas canvas, Size size) {
    alleys.asMap().forEach((index, alley) {
      setColor(alley);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                getLeft(index),
                getTop(index),
                blocSize - gap,
                blocSize - gap,
              ),
              Radius.circular(1.0)),
          painter);
    });
  }

  double getTop(int index) {
    return (index / crossAxisCount).floor().toDouble() * blocSize;

  }

  double getLeft(int index) {
    return (index % crossAxisCount).floor().toDouble() * blocSize;
  }

  @override
  bool shouldRepaint(CustomGridView oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(CustomGridView oldDelegate) => true;

  void setColor(Alley alley) {
    switch (alley.type) {
      case "ALLEY":
        painter.color = CustomTheme().mapColor1;
        break;
      case "SHELF":
        painter.color = CustomTheme().mapColor2;
        break;
      case "CASH":
        painter.color = CustomTheme().mapColor3;
        break;
      case "UNUSED":
        painter.color = Colors.transparent;
        break;
    }
  }
}
