import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // set the paint color to be white
    // paint.color = Color(0xffe25979);
    // paint.style = PaintingStyle.fill; // Change this to fill

    // var path = Path();

    // path.moveTo(0, size.height * 0.25);
    // path.quadraticBezierTo(
    //     size.width / 2, size.height / 2, size.width, size.height * 0.25);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);

    // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
