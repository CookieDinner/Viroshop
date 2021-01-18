import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Alley.dart';
import 'package:viroshop/World/Order.dart';
import 'package:viroshop/World/Product.dart';
import 'package:viroshop/World/Templates/ProductTemplate.dart';

import 'QRCode.dart';


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
  List<Offset> path = [];

  int columnsCount;
  double blocSize;
  int clickedIndex;
  Offset clickOffset;
  bool hasSizes = false;
  double outerPadding;
  StreamController<bool> streamControllerMap = StreamController<bool>();
  StreamController<bool> streamControllerPath = StreamController<bool>();
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
    streamControllerMap.close();
    streamControllerPath.close();
    super.dispose();
  }

  Future<void> updateSize(Alley alley) async{
    setState(() {
      allCount = alley.id;
      crossAxisCount = alley.xposition;
    });
  }

  Future<void> getShortestPath() async{
    List<dynamic> requestPath = jsonDecode(await Requests.getShortestPath(widget.currentOrder.products));
    for (Map<String, dynamic> pathElement in requestPath) {
      path.add(Offset(
          (pathElement["x"] - 0.5) * blocSize,
          (pathElement["y"] - 0.5) * blocSize));
    }
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
      streamControllerMap.add(true);

      await getShortestPath();
      streamControllerPath.add(true);
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
      List<Product> maybeProducts = [];
      for (Product possibleProduct in widget.currentOrder.products) {
        if (alleysList[clickedIndex].products.any((element) =>
        element.id == possibleProduct.id))
          maybeProducts.add(possibleProduct);
      }
      String message = "";
      for(Product wowProduct in maybeProducts)
        message += wowProduct.name + " x " + wowProduct.amount.toString() + "\n";
      if (message.isNotEmpty)
        CustomAlerts.showAlertDialog(context, "Produkty w wybranej alejce:", message);
      // setState(() {
      //   alleysList[clickedIndex].type = "CLICKED";
      // });
    }
  }

  ScrollController _scrollController = ScrollController();

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
                          GestureDetector(
                            onTap: onTap,
                            onTapDown: onTapDown,
                            child: Stack(
                              children: [
                                StreamBuilder<Object>(
                                  stream: streamControllerMap.stream ,
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData) {
                                      return Container(
                                        width: mediaSize.width * 0.9,
                                        height: mediaSize.width * 0.9,
                                        child: CustomPaint(
                                          painter: CustomGridView(
                                            alleys: alleysList,
                                            columnsCount: columnsCount,
                                            blocSize: blocSize,
                                            allCount: allCount,
                                            crossAxisCount: crossAxisCount,
                                            order: widget.currentOrder
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
                                ),
                                StreamBuilder<Object>(
                                    stream: streamControllerPath.stream,
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData) {
                                        return Container(
                                          width: mediaSize.width * 0.9,
                                          height: mediaSize.width * 0.9,
                                          child: CustomPaint(
                                            painter: ShortestPath(
                                                path: path,
                                                columnsCount: columnsCount,
                                                blocSize: blocSize,
                                                allCount: allCount,
                                                crossAxisCount: crossAxisCount,
                                                mediaSize: mediaSize
                                            ),
                                          ),
                                        );
                                      }else{
                                        return Container(
                                          width: mediaSize.width * 0.9,
                                          height: mediaSize.width * 0.9,
                                          child: Center(
                                            child: SpinKitFadingCube(
                                              color: CustomTheme().accentPlus,
                                              size: MediaQuery.of(context).size.width * 0.1,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: mediaSize.width * 0.04,),
                              Container(
                                  height: mediaSize.height * 0.4,
                                  width: mediaSize.width * 0.45,
                                  child: DraggableScrollbar.rrect(
                                    alwaysVisibleScrollThumb: true,
                                    backgroundColor: CustomTheme().accent,
                                    heightScrollThumb: widget.currentOrder.products.length > 6 ?
                                    mediaSize.height * 2 / widget.currentOrder.products.length : 0,
                                    padding: EdgeInsets.all(1),
                                    controller: _scrollController,
                                    child: ListView.builder(
                                        controller: _scrollController,
                                        itemCount: widget.currentOrder.products.length,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: mediaSize.height * 0.003),
                                            child: ProductTemplate(widget.currentOrder.products[index], null, isSmall: true,),
                                          );
                                        }
                                    ),
                                  )
                              ),
                              SizedBox(width: mediaSize.width * 0.06,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: mediaSize.height * 0.03,),
                                  Container(
                                      child: Text("Pozostały czas:",
                                        style: TextStyle(
                                            color: CustomTheme().accentText,
                                            fontSize: mediaSize.width * Constants.appBarFontSize
                                        ),
                                      )
                                  ),
                                  SizedBox(height: mediaSize.height * 0.01,),
                                  Container(
                                      width: mediaSize.width * 0.4,
                                      child: Text("15:00",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: CustomTheme().standardText,
                                            fontSize: mediaSize.width * Constants.appBarFontSize * 0.9
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                  ),
                                  SizedBox(height: mediaSize.height * 0.07,),
                                  Container(
                                      width: mediaSize.width * 0.4,
                                      height: mediaSize.height * 0.1,
                                      child: Button("Kod QR", (){
                                        Navigator.of(context).push(
                                            CustomPageTransition(
                                              QRCode(widget.currentOrder),
                                              x: 0.0,
                                              y: 0.1,
                                            )
                                        );
                                      })
                                  ),
                                ],
                              ),
                            ],
                          ),
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
  final int columnsCount;
  final double blocSize;
  final List<Alley> alleys;
  final int allCount;
  final int crossAxisCount;
  final Order order;

  CustomGridView({this.columnsCount, this.blocSize, this.alleys, this.allCount, this.crossAxisCount, this.order});

  final double gap = 1;
  final Paint painter = Paint()
    ..strokeWidth = 1
    ..style = PaintingStyle.fill;

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
        if (alley.products.any((element) => order.products.any((element1) => element.id == element1.id)))
          painter.color = Colors.green;
        else
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

class ShortestPath extends CustomPainter{
  final int columnsCount;
  final double blocSize;
  final List<Offset> path;
  final int allCount;
  final int crossAxisCount;
  final Size mediaSize;
  ShortestPath({this.columnsCount, this.blocSize, this.path, this.allCount, this.crossAxisCount, this.mediaSize});
  
  @override
  void paint(Canvas canvas, Size size){
    final pointMode = ui.PointMode.polygon;
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, path, paint);
  }

  @override
  bool shouldRepaint(ShortestPath oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(ShortestPath oldDelegate) => true;
}
