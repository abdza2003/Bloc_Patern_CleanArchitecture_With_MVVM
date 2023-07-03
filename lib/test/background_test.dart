import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 243, 33, 33)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width, 0);
    path0.quadraticBezierTo(size.width, size.height * 0.0300000, size.width,
        size.height * 0.0400000);
    path0.quadraticBezierTo(size.width * 0.3450000, size.height * 0.4489286, 0,
        size.height * 0.0885714);
    path0.lineTo(0, 0);

    canvas.drawPath(path0, paint0);

    Paint paint1 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path1 = Path();
    path1.moveTo(size.width, 0);
    path1.quadraticBezierTo(size.width, size.height * 0.0428571, size.width,
        size.height * 0.0571429);
    path1.cubicTo(
        size.width * 0.5231250,
        size.height * 0.3153571,
        size.width * 0.2306250,
        size.height * 0.2367857,
        0,
        size.height * 0.0628571);
    path1.quadraticBezierTo(0, size.height * 0.0471429, 0, 0);

    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
