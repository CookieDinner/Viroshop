import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/World/Order.dart';

class QRCode extends StatefulWidget {
  final Order order;
  QRCode(this.order);
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  StreamController<bool> streamController = StreamController<bool>();


  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                  children : <Widget> [
                    BackgroundAnimation(),
                    Center(
                      child: Container(
                        color: Colors.white,
                        width: mediaSize.width,
                        child: QrImage(
                          data: "order:${widget.order.id},"+
                                "username:${Data().currentUsername},"+
                                "password:${Data().loginKey},"+
                                "qrEnterStore",
                          version: QrVersions.auto,
                          gapless: true,
                        ),
                      )
                    ),
                    CustomAppBar("Kod QR wejścia do sklepu"),
                  ]
              ),
            ),
          ),
        )
    );
  }
}
