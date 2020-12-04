import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ZbikPayment/ZbikButton.dart';

class ZbikFinalView extends StatefulWidget {
  @override
  _ZbikFinalViewState createState() => _ZbikFinalViewState();
}

class _ZbikFinalViewState extends State<ZbikFinalView> {

  void simulateCorrectPayment() {
    // TODO: Here handle correct payment
    print('Payment result: CORRECT');
  }

  void simulateErrorPayment() {
    // TODO: Here handle error payment
    print('Payment result: ERROR');
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return Container(
        height: mediaSize.height,
        width: mediaSize.width,
        color: new Color.fromARGB(200, 60, 210, 50),
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ZbikButton(text: "Zasymuluj prawidłową płatność", onClick: simulateCorrectPayment),
              ZbikButton(text: "Zasymuluj błąd płatności", onClick: simulateErrorPayment),
            ]));
  }
}
