import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = AppColor.primary.withOpacity(0.6);
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(0, size.height * 0.175, 0, size.height * 0.1200);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.075,
        size.width * 0.5, size.height * 0.067);
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.074,
        size.width * 1.0, size.height * 0.367);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = AppColor.primary.withOpacity(0.5);
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(0, size.height * 0.355, 0, size.height * 0.3500);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.175,
        size.width * 0.5, size.height * 0.2267);
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.2584,
        size.width * 1.0, size.height * 0.0567);
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
