import 'package:flutter/material.dart';

class SichelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    Offset center = Offset(size.width/2, size.height/2.0);
    final bounds = Rect.fromCircle(center: center, radius: 175.0);

    final path = Path();
    path.moveTo(size.width/15, size.height/20);
    path.lineTo(size.width/15, size.height/7);
    path.quadraticBezierTo(size.width/5, 0.0, size.width/3, size.height/20);
    path.lineTo(size.width/15, size.height/20);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(SichelClipper oldClipper) => false;



}