import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NetworkingPageHeader implements SliverPersistentHeaderDelegate {
  NetworkingPageHeader({
    this.minExtent,
    @required this.maxExtent,
    @required this.headerName,
    @required this.picRef,
  });
  final double minExtent;
  final double maxExtent;
  final String headerName;
  final String picRef;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          picRef ?? 'assets/Thabs.png',//'https://r-cf.bstatic.com/images/hotel/max1024x768/116/116281457.jpg',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.white],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              headerName,
              style: TextStyle(
                fontFamily: 'FiraSansExtraCondensed',
                fontSize: 32.0/((shrinkOffset/1300)+1),
                color: Colors.black,//Colors.white.withOpacity(titleOpacity(shrinkOffset)),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              )

            ),
          ),
        )
      ],
    );
  }

  double titleOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration => null;//throw UnimplementedError();

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  // TODO: implement vsync
  TickerProvider get vsync => null;
}