import 'package:flutter/material.dart';

class NeoContainer extends StatelessWidget {
  final Color containerColor;
  final Color shadowColor1;
  final Color shadowColor2;
  final int animationDuration;
  final double containerHeight;
  final double containerWidth;
  final String containerText;
  final double shadow1Offset;
  final double shadow2Offset;
  final double blurRadius1;
  final double blurRadius2;
  final double spreadRadius1;
  final double spreadRadius2;
  final BoxShape containerBoxShape;
  final BorderRadiusGeometry containerBorderRadius;
  final Widget containerChild;
  final String imagePath;
  final bool circleShape;
  final Color gradientColor1;
  final Color gradientColor2;
  final Color gradientColor3;
  final Color gradientColor4;
  final Color borderColor;


  const NeoContainer(
      {Key key, this.containerColor, @required this.shadowColor1, @required this.shadowColor2, this.animationDuration, this.containerHeight, this.containerWidth, this.containerText,
        this.blurRadius1, this.blurRadius2, this.shadow1Offset, this.shadow2Offset, this.spreadRadius1, this.spreadRadius2, this.containerBoxShape, this.containerBorderRadius, this.containerChild, this.imagePath,
        this.circleShape, this.gradientColor1, this.gradientColor2, this.gradientColor3, this.gradientColor4, this.borderColor}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (circleShape == false) {
      return Container(
        height: containerHeight ?? 10.0,
        width: containerWidth ?? 20.0,
        decoration: BoxDecoration(
          borderRadius: containerBorderRadius ??
              BorderRadius.all(Radius.circular(10.0)),
        ),
        child: AnimatedContainer(
          duration: Duration(seconds: animationDuration ?? 1),
          decoration: BoxDecoration(
            //shape: containerBoxShape ?? BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientColor1 ?? Colors.grey[200] ,gradientColor2 ?? Colors.grey[300] , gradientColor3 ?? Colors.grey[400], gradientColor4 ?? Colors.grey[500]],
              stops: [0.1, 0.3, 0.8, 0.9]
            ),
              border: Border.all(
                color: borderColor ?? Colors.transparent,
              ),
              borderRadius: containerBorderRadius ??
                  BorderRadius.all(Radius.circular(10.0)),
              // BorderRadius.all(Radius.circular(10.0)
              color: containerColor ?? Colors.white,
              boxShadow: [
                BoxShadow(
                    color: shadowColor1 ?? Colors.transparent,
                    offset: Offset(shadow1Offset ?? 4.5, shadow1Offset ?? 4.5),
                    //4.5 both
                    blurRadius: blurRadius1 ?? 3.0,
                    // 15.0
                    spreadRadius: spreadRadius1 ?? 1.0), // 1.0
                BoxShadow(
                  color: shadowColor2 ?? Colors.transparent,
                  offset: Offset(shadow2Offset ?? -2.0, shadow2Offset ?? -2.0),
                  // -4.5 both
                  blurRadius: blurRadius2 ?? 3.0,
                  // 15.0
                  spreadRadius: spreadRadius2 ?? 1.0,), // 1.0
              ]
          ),
          child: containerChild ?? Center(
              child: Text(containerText ?? '',
                style: TextStyle(
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14.0
                ),)),
        ),
      );
    } else if (circleShape == true) {
      return Container(
        height: containerHeight ?? 10.0,
        width: containerWidth ?? 20.0,
        child: AnimatedContainer(
          duration: Duration(seconds: animationDuration ?? 1),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: containerColor ?? Colors.white,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradientColor1 ?? Colors.grey[200] ,gradientColor2 ?? Colors.grey[300] , gradientColor3 ?? Colors.grey[400], gradientColor4 ?? Colors.grey[500]],
                  stops: [0.1, 0.3, 0.8, 0.9]
              ),
              boxShadow: [
                BoxShadow(
                    color: shadowColor1 ?? Colors.transparent,
                    offset: Offset(shadow1Offset ?? 2.0, shadow1Offset ?? 2.0),
                    //4.5 both
                    blurRadius: blurRadius1 ?? 2.0,
                    // 15.0
                    spreadRadius: spreadRadius1 ?? 1.0), // 1.0
                BoxShadow(
                  color: shadowColor2 ?? Colors.transparent,
                  offset: Offset(shadow2Offset ?? -2.0, shadow2Offset ?? -2.0),
                  // -4.5 both
                  blurRadius: blurRadius2 ?? 2.0,
                  // 15.0
                  spreadRadius: spreadRadius2 ?? 1.0,), // 1.0
              ]
          ),
          child: containerChild ?? Center(
              child: Text(containerText ?? '',
                style: TextStyle(
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14.0
                ),)),
        ),
      );
    }
  }
}