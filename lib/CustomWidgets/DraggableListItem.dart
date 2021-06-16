import 'package:flutter/material.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DraggableWidget extends StatefulWidget{

  final String customWidgetString;
  final String workoutLocation;
  final Key key;

  const DraggableWidget({this.key, this.customWidgetString, this.workoutLocation}) : super(key: key);

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}



class _DraggableWidgetState extends State<DraggableWidget> {
  Widget _widget(context){
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01, right: MediaQuery.of(context).size.width*0.02, left: MediaQuery.of(context).size.width*0.02, bottom: MediaQuery.of(context).size.height*0.01),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.075),
              child: NeoContainer(
                circleShape: true,
                containerHeight: MediaQuery.of(context).size.width*0.1,
                containerWidth: MediaQuery.of(context).size.width*0.1,
                shadowColor1: Colors.black,
                shadowColor2: Colors.white,
                gradientColor1: Theme.of(context).primaryColor,
                gradientColor2: Theme.of(context).primaryColor,
                gradientColor3: Theme.of(context).primaryColor,
                gradientColor4: Theme.of(context).primaryColor,
                containerChild: Center(
                  child: Text(
                    widget.workoutLocation,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FiraSansExtraCondensed'
                    ),
                  ),
                ),
              ),
            ),
            NeoContainer(
              circleShape: false,
              containerHeight: MediaQuery.of(context).size.height/6,
              containerWidth: MediaQuery.of(context).size.width*0.7,
              shadowColor1: Colors.black,
              shadowColor2: Colors.white,
              gradientColor1: Theme.of(context).primaryColor,
              gradientColor2: Theme.of(context).primaryColor,
              gradientColor3: Theme.of(context).primaryColor,
              gradientColor4: Theme.of(context).primaryColor,
              containerChild: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(widget.customWidgetString,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'FiraSansExtraCondensed',
                              fontSize: 30.0
                          ),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image(
                            height: 40.0,
                            width: 120.0,
                            image: AssetImage(
                              'assets/Exopek_Logo.png',

                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.18),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: MediaQuery.of(context).size.height/15,
                          width: MediaQuery.of(context).size.width/40,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.19),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: MediaQuery.of(context).size.height/80,
                          width: MediaQuery.of(context).size.width/4,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return _widget(context);
  }
}
