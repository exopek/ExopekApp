import 'package:flutter/material.dart';
import 'package:video_app/CustomWidgets/buttonClipper.dart';

class BlankPage extends StatelessWidget {
  final result;

  const BlankPage({Key key, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
          child: Center(
            child: Text(
              result,
              style: TextStyle(
                color: Colors.white
              ),
            ),
          )
      ),
    );
  }
}
