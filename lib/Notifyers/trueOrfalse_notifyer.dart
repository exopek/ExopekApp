import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrueOrFalseNotifyer extends ChangeNotifier{

  bool _state = false;

  get trueOrFalse {
    return _state;
  }


  updateTrueOrFalse(bool newState) {
    _state = newState;
    notifyListeners();
  }
}