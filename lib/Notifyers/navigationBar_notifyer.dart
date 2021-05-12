import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class navbarColor extends ChangeNotifier {
  var _nIC1;
  var _nIC2;
  var _nIC3;
  var _index;
  bool _firstCall = false;

  get index {
    if (_firstCall == false) {
      return 0;
    }
    return _index;
  }

  get navIconColor1 {
    if (_firstCall == false) {
      return Colors.white;
    }
    return _nIC1;
  }

  get navIconColor2 {
    if (_firstCall == false) {
      return Colors.grey;
    }
    return _nIC2;
  }

  get navIconColor3 {
    if (_firstCall == false) {
      return Colors.grey;
    }
    return _nIC3;
  }

  updatenavIconColor(bool _tab1, bool _tab2, bool _tab3) {
    _firstCall = true;
    if (_tab1 == true) {
      _nIC1 = Colors.white;
      _nIC2 = Colors.grey;
      _nIC3 = Colors.grey;
      _index = 0;
    }
    else if (_tab2 == true) {
      _nIC1 = Colors.grey;
      _nIC2 = Colors.white;
      _nIC3 = Colors.grey;
      _index = 1;
    }
    else if (_tab3 == true) {
      _nIC1 = Colors.grey;
      _nIC2 = Colors.grey;
      _nIC3 = Colors.white;
      _index = 2;
    }
    notifyListeners();
  }

}