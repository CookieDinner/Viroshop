import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ZbikPayment/ZbikButton.dart';

import 'ZbikFinalView.dart';

class ZbikPaymentView extends StatefulWidget {
  @override
  _ZbikPaymentViewState createState() => _ZbikPaymentViewState();
}

class _ZbikPaymentViewState extends State<ZbikPaymentView> {

  void goToPaymentResult() {
    Navigator.of(context).push(
        CustomPageTransition(
          ZbikFinalView(),
          x: 0.0,
          y: 0.5,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
      child: Container(
          height: mediaSize.height,
          width: mediaSize.width,
          color: new Color.fromARGB(200, 60, 210, 50),
          alignment: Alignment.center,
          child: Stack(
            children: [
              Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    mediaSize.width * 0.24,
                    mediaSize.height * 0.05,
                    mediaSize.width * 0.24,
                    0,
                  ),
                  child: Image.asset('assets/images/zbiklogo.png'),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                    child: Center(
                      child: Text("System płatności ŻBIK",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.none,
                          )),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                                "Wybierz sposób płatności",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.none,
                                )
                          ),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ZbikButton(text: "BLIK", onClick: goToPaymentResult,),
                              ZbikButton(text: "Portfel ŻBIK", onClick: goToPaymentResult),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ZbikButton(text: "Karta płatnicza", onClick: goToPaymentResult),
                              ZbikButton(text: "Szybki przelew", onClick: goToPaymentResult),
                            ],
                          ),
                        ],
                      ),
                    ))
              ]),
              CustomAppBar("", specialColor: Colors.black,),
            ],
          )),
    );
  }
}
