import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ZbikPayment/ZbikButton.dart';

class ZbikPaymentView extends StatefulWidget {
  @override
  _ZbikPaymentViewState createState() => _ZbikPaymentViewState();
}

class _ZbikPaymentViewState extends State<ZbikPaymentView> {
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
        height: mediaSize.height,
        width: mediaSize.width,
        color: new Color.fromARGB(200, 60, 210, 50),
        alignment: Alignment.center,
        child: Column(children: <Widget>[
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
              padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        ZbikButton(text: "BLIK"),
                        ZbikButton(text: "Portfel ŻBIK"),
                      ],
                    ),
                    Row(
                      children: [
                        ZbikButton(text: "Karta płatnicza"),
                        ZbikButton(text: "Szybki przelew"),
                      ],
                    ),
                  ],
                ),
              ))
        ]));
  }
}
