import 'dart:math';
import 'package:flutter/material.dart';

class OvalVideoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    Offset center = Offset(size.width/2, size.height/2.0);
    final bounds = Rect.fromCircle(center: center, radius: 175.0);

    final path = Path();
    path.moveTo(0.0, size.height/2.89);
    path.quadraticBezierTo(size.width/2, size.height/2.6, size.width, size.height/2.89);
    //path.quadraticBezierTo(size.width/2, -90.0, size.width/19, size.height/3.6);
    path.arcTo(bounds, 1.1*pi, 0.8*pi, false);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;



}