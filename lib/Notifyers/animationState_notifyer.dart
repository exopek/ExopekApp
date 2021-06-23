import 'dart:developer';
import 'package:flutter/material.dart';

class AnimationStateNotifier extends ChangeNotifier {


  ///ToDo: Hier muss ein Future hin, welches eine Aussage über die Anzahl der Übungen gibt
  var animationStates = new List.filled(4, false);
  var lastAnimationValueList = new List.filled(4, 0.0);
  bool scrollPage = false;


  List animationValue() {
    return lastAnimationValueList;
  }

  List animationState() {
    return animationStates;
  }

  bool scrollPageState() {
    return scrollPage;
  }

  updatePage(bool movePage) {
    scrollPage = movePage;
    notifyListeners();
  }

  updateListLength(int listLen) {
    animationStates = new List.filled(listLen, false);
    lastAnimationValueList = new List.filled(listLen, 0.0);
    //notifyListeners();
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