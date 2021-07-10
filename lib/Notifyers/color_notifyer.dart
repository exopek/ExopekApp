import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorNotifyer extends ChangeNotifier{
  var _color1 = [Colors.red, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  bool _firstCall = false;
  final context;
  int _index = 0;

  ColorNotifyer({@required this.context});

  get index {
    return _index;
  }

  get tabColor1 {
    return _color1;
  }


  updateTabColor(int index, context) {
    _color1 = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
    _color1.removeAt(index);
    _color1.insert(index, Colors.red);
    notifyListeners();
  }
}