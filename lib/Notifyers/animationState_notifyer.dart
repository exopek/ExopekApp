import 'dart:developer';
import 'package:flutter/material.dart';

class AnimationStateNotifier extends ChangeNotifier {


  ///ToDo: Hier muss ein Future hin, welches eine Aussage über die Anzahl der Übungen gibt
  var animationStates = new List.filled(4, false);
  var lastAnimationValueList = new List.filled(4, 0.0);


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