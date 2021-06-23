import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NetworkingPageHeader implements SliverPersistentHeaderDelegate {
  NetworkingPageHeader({
    this.minExtent,
    @required this.maxExtent,
    @required this.headerName,
    this.picRef,
    @required this.showBackButton,
    @required this.expandPic
  });
  final bool showBackButton;
  final double minExtent;
  final double maxExtent;
  final String headerName;
  final String picRef;
  final bool expandPic;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Scaffold(

        body: _fillContent(context, shrinkOffset)
    );
  }

  Widget _fillContent(BuildContext context, double shrinkOffset) {
    if (expandPic == true) {
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
          _backButton(context)
        ],
      );
    } else {
      return Container(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                picRef ?? 'assets/Thabs.png',//'https://r-cf.bstatic.com/images/hotel/max1024x768/116/116281457.jpg',
                fit: BoxFit.cover,
              ),
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
                    color: Colors.black.withOpacity(titleOpacity(shrinkOffset)),
                  ),
                ),
              ),
            ),
            _backButton(context)
          ],
        ),
      );
    }
  }

  Widget _backButton(BuildContext context) {
    if (showBackButton == true) {
      return SafeArea(
       // child: Padding(
          //padding: EdgeInsets.only(top: 27.0, left: 4.0),
          child: Align(
            alignment: Alignment.topLeft,
            /*
            child: GestureDetector(

                onTap: () {
                  Navigator.pop(context);
                },
    */
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent
                  ),
                  height: 50.0,
                  width: 50.0,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    splashColor: Colors.grey,
                    splashRadius: 60.0,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                )

           // ),
          ),
       // ),
      );
    } else {
      return Container();
    }
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