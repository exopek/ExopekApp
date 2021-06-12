import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Services/database_handler.dart';

class AnimationStateNotifier extends ChangeNotifier {


  ///ToDo: Hier muss ein Future hin, welches eine Aussage über die Anzahl der Übungen gibt
  var animationStates = new List.filled(3, false);
  var lastAnimationValueList = new List.filled(3, 0.0);


  List animationValue() {
    return lastAnimationValueList;
  }

  List animationState() {
    return animationStates;
  }

  updateAnimationState(int page, bool completed) {
    log('page: $page');
    log('complete: $completed');
    animationStates[page] = completed;
    log('animationState: ${animationStates[page]}');
    notifyListeners();
  }

  holdAnimationValues(int page, double animationValue) {
    lastAnimationValueList[page] = animationValue;
  }


}