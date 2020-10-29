import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/Utilities/Constants.dart';

  class Button extends StatelessWidget{
    final String label;
    final Function fun;
    Button(this.label, this.fun);

    @override
    Widget build(BuildContext context) {
      final mediaSize = MediaQuery.of(context).size;
      return Container(
        width: double.infinity,
        height: mediaSize.height * 0.06,
        color: Constants.accent,
        child: FlatButton(
          onPressed: () => fun(),
          child: Text(label,style: TextStyle(fontSize: mediaSize.height * 0.026, color: Colors.white, fontWeight: FontWeight.w400),),
        ),
      );
    }
  }

  class Spinner extends StatelessWidget{
    final TickerProvider provider;
    final size;
    final Function fun;
    Spinner(this.size, this.provider, this.fun);

    @override
    Widget build(BuildContext context) {
      Future(()=>fun());
      return Container(
        height: MediaQuery.of(context).size.height * 0.06,
        child: SpinKitFadingCube(
          color: Constants.accent,
          size: MediaQuery.of(context).size.width * 0.09,
          controller: AnimationController(
            vsync: provider, duration: const Duration(milliseconds: 1500)
          ),
        ),
      );
    }
  }