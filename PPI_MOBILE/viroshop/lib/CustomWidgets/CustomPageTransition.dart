import 'package:flutter/material.dart';

class CustomPageTransition extends PageRouteBuilder{
  final Widget widget;
  final double x;
  final double y;
  CustomPageTransition(this.widget, {this.x = 0, this.y = 0}) : super (
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return ScaleTransition(
          scale: animation,
          alignment: Alignment(x, y),
          child: child,);
      }
  );
}