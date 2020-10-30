import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'dart:math';

class BackgroundAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children : <Widget>[
          AnimatedWave(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.3,
            speed: 0.6,
            offset: pi,
            color: Constants.backgroundWave3,
            a: 1,
            b: 1,
            c: 1,
          ),
          AnimatedWave(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.2,
            speed: 0.5,
            offset: pi / 2,
            color: Constants.backgroundWave2,
            a: 1,
            b: 1,
            c: 1,
          ),
          AnimatedWave(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            speed: 0.4,
            color: Constants.backgroundWave1,
            a: 1,
            b: 1,
            c: 1,
          ),
        ]
    );
  }
}

class AnimatedWave extends StatelessWidget {
  final double width;
  final double height;
  final double speed;
  final double offset;
  final Color color;
  final double a;
  final double b;
  final double c;

  AnimatedWave({this.width = 200, this.height = 200, this.speed = 1.0, this.offset = 0.0, this.color = Colors.blueAccent, this.a = 1, this.b = 1, this.c = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            width: width,
            // ignore: deprecated_member_use
            child: ControlledAnimation(
              // ignore: deprecated_member_use
                playback: Playback.LOOP,
                duration: Duration(milliseconds: (5000 / speed).round()),
                tween: Tween(begin: 0.0, end: 2 * pi),
                builder: (context, value) {
                  return CustomPaint(
                    foregroundPainter: CurvePainter(value + offset, color, height, a: a, b: b, c: c),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double value;
  final Color waveColor;
  final double height;
  final double a;
  final double b;
  final double c;

  CurvePainter(this.value, this.waveColor, this.height, {this.a = 1, this.b = 1, this.c = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final color = Paint()..shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        waveColor,
        Constants.weirdWhite,
      ],
    ).createShader(Rect.fromCircle(
      center: Offset(0.0, 0.0),
      radius: height / 1.5,
    ));
    final path = Path();

    final y1 = sin(a*value);
    final y2 = sin(b*(value + pi / 2));
    final y3 = sin(c*(value + pi));

    final startPointY = size.height * (0.4 * y1);
    final controlPointY = size.height * (0.4 * y2);
    final endPointY = size.height * (0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}