import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Product.dart';

class CartPopup{
  final Product _currentProduct;
  final Widget _image;
  final int _preAmount;
  final _cartId;
  final Function _extraFunction;
  CartPopup(this._currentProduct, this._image, {preAmount, cartId, extraFunction}) : _preAmount = preAmount, _cartId = cartId, _extraFunction = extraFunction;

  bool _isCurrentlyProcessing = false;
  void addToCart(BuildContext context, int quantity) async{
    if(_isCurrentlyProcessing || quantity == 0)
      return;
    _isCurrentlyProcessing = true;
    if (_preAmount == null)
      await DbHandler.insertToCart(Data().currentShop, _currentProduct, quantity);
    else {
      await DbHandler.editCart(Data().currentShop, _currentProduct, quantity);
      _extraFunction();
    }
    _isCurrentlyProcessing = false;
    Navigator.pop(context);
  }
  void showPopup(BuildContext context, bool mode) async{
    int currentQuantity = _preAmount ?? 0;
    final mediaSize = Util.getDimensions(context);
    await showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState){
            return AlertDialog(
              backgroundColor: CustomTheme().popupBackground,
              title: Text(!mode ? "Dodaj do koszyka" : "Edytuj produkt w koszyku", style: TextStyle(color: CustomTheme().accentText),),
              content: Container(
                  height: mediaSize.height * 0.3,
                  width: mediaSize.width * 0.68,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: mediaSize.height * 0.08,
                            width: mediaSize.height * 0.08,
                            child: _image,
                          ),
                          SizedBox(width: mediaSize.width * 0.03,),
                          Container(
                              width: mediaSize.width * 0.30,
                              child: Text(
                                _currentProduct.name,
                                style: TextStyle(
                                    color: CustomTheme().standardText,
                                    fontSize: mediaSize.aspectRatio * 35
                                ),
                              )
                          ),
                          Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Obecna cena:",
                                    style: TextStyle(
                                        color: CustomTheme().standardText,
                                        fontSize: mediaSize.aspectRatio * 27
                                    ),
                                  ),
                                  SizedBox(height: mediaSize.height * 0.003,),
                                  Text(
                                    (_currentProduct.price * currentQuantity).toStringAsFixed(2) + " zł",
                                    style: TextStyle(
                                        color: CustomTheme().standardText,
                                        fontSize: mediaSize.aspectRatio * 32
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                      Spacer(),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(border: Border(
                                bottom: BorderSide(width: 1,
                                    color: CustomTheme().accent))),
                            height: mediaSize.height * 0.078,
                            width: mediaSize.width,
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border(
                                bottom: BorderSide(width: 1,
                                    color: CustomTheme().accent))),
                            height: mediaSize.height * 0.122,
                            width: mediaSize.width,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: mediaSize.height * 0.2,
                                  width: mediaSize.width * 0.2,
                                  child: CarouselSlider.builder(
                                      itemCount: 999,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(
                                          child: Text(index.toString(),
                                            style: TextStyle(
                                              fontSize: mediaSize.height * 0.035,
                                              color: CustomTheme().standardText
                                            ),
                                            textAlign: TextAlign.center,),
                                        );
                                      },
                                      options: CarouselOptions(
                                        initialPage: currentQuantity,
                                        onPageChanged: (index, _) {
                                          setState(() {
                                            currentQuantity = index;
                                          });
                                        },
                                        enableInfiniteScroll: false,
                                        scrollDirection: Axis.vertical,
                                        scrollPhysics: AlwaysScrollableScrollPhysics(),
                                        enlargeCenterPage: true,
                                        viewportFraction: 0.23,
                                      )
                                  )
                              ),
                              Text("szt",
                                style: TextStyle(
                                    fontSize: mediaSize.height * 0.035,
                                    color: CustomTheme().standardText
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              actions: [
                Container(
                  width: mediaSize.width * 0.77,
                  height: mediaSize.height * 0.09,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: CustomTheme().textBackground.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        width: mediaSize.width * 0.3,
                        height: mediaSize.height * 0.06,
                        child: OutlineButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Anuluj", style: TextStyle(color: CustomTheme().standardText),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: currentQuantity == 0 ?
                            Colors.grey : CustomTheme().buttonColor,
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        width: mediaSize.width * 0.3,
                        height: mediaSize.height * 0.06,
                        child: OutlineButton(
                          highlightColor: currentQuantity == 0 ? Colors.transparent : CustomTheme().accent,
                          splashColor: currentQuantity == 0 ? Colors.transparent : CustomTheme().accent,
                          highlightedBorderColor: currentQuantity == 0 ? Colors.transparent : CustomTheme().standardText,
                          onPressed: () => addToCart(context, currentQuantity),
                          child: Text(!mode ? "Dodaj" : "Edytuj", style: TextStyle(color: CustomTheme().standardText),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ],
              elevation: 15,
              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
            );
          },
        );
      },
    );
  }
}
