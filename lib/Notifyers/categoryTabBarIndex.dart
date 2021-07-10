import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Services/database_handler.dart';

class CTabBarIndex extends ChangeNotifier {
  var _index;
  final context;
  Stream _stream;
  List<Stream> _currentStreamList;
  bool _firstVisit = false;

  CTabBarIndex({@required this.context});

  get cTabBarStream {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context, listen: false);
    if (_firstVisit == false) {
      return database.allWorkoutStream();
    } else {
      return _stream;
    }
  }

  get cTabBarIndex {
    if (_firstVisit == false) {
      _firstVisit = true;
      return _index = 0;
    } else {
      return _index;
    }

  }

  updateCategary(String category, context) {

    notifyListeners();
  }

  updateIndex(int Index, String category, context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context, listen: false);
    List<Stream> functionalStreams = [];
    List<Stream> excerciseStreams = [database.allWorkoutStream() ,database.chestWorkoutStream() ,database.legWorkoutStream(), database.backWorkoutStream(), database.shoulderWorkoutStream(), database.armWorkoutStream(), database.absWorkoutStream()];
    List<Stream> mobilityStream = [];
    if (category == 'Functional') {
      _currentStreamList = functionalStreams;
    } else if (category == 'Excercises') {
      _currentStreamList = excerciseStreams;
    } else if (category == 'Mobility') {
      _currentStreamList = mobilityStream;
    } else if (category == 'Konfigurator') {
      _currentStreamList = excerciseStreams;
    }
    _index = Index;
    _stream = _currentStreamList[Index];
    _firstVisit = true;
    notifyListeners();
  }
}