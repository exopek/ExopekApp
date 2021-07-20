import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:video_app/CustomWidgets/animationWidget.dart';
import 'package:video_app/CustomWidgets/training_finish_widget.dart';
import 'package:video_app/Notifyers/animationState_notifyer.dart';


class YoutubePage extends StatefulWidget {

  final List artboardList;
  final int trainingSeconds;
  final int pauseSeconds;
  final int sets;
  final List workout;
  final String routine;
  final List thumbnail;
  final List muscle;
  final List level;

  const YoutubePage({Key key, this.artboardList, this.trainingSeconds, this.pauseSeconds, this.sets, this.workout, this.routine, this.level, this.thumbnail, this.muscle}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<YoutubePage> with TickerProviderStateMixin {
  void _togglePlay() {
    //setState(() => _controller.isActive = !_controller.isActive);
    setState(() {
      _controller.isActive = !_controller.isActive;
      //_showCheckAnimation = !_showCheckAnimation;
      _pageController.jumpToPage(_pageController.page.round() + 1);
    });
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;


  /// Map for animation Controller
  ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  int _previousPage;


  /// ToDo: Hier muss ein Future hin

  List _durations = [];


  bool _finish;
  Timer _timer;
  int _pageIndex;
  int _nextArtBoardIndex;
  double viewportFraction = 0.0;
  PageController _pageController;

  var artboardMap = new Map();
  Map<int, Animation> animationControllerMap = {};
  AnimationController _animationController;

  RiveAnimationController _controller;

  int _setCounter;
  @override
  void initState() {
    super.initState();
    final AnimationStateNotifier animationStateNotifier = Provider.of<AnimationStateNotifier>(context, listen: false);
    animationStateNotifier.updateListLength(widget.artboardList.length);
    _pageIndex = 0;
    _finish = false;
    _setCounter = 1;
    _durations = List.generate(widget.artboardList.length, (index) => widget.trainingSeconds);
    _pageController = PageController(
        initialPage: 0);

    _timer = Timer.periodic(Duration(seconds: widget.trainingSeconds + widget.pauseSeconds + 2), (Timer timer) {
      if (_pageIndex < widget.artboardList.length-1) {
        _pageIndex++;
      } else {
        if (_setCounter < widget.sets) {
          _pageIndex = 0;
          _setCounter++;
        } else {
          _pageIndex =_pageIndex;
        }

      }

      _pageController.animateToPage(
        _pageIndex,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });


    _pageController.addListener(_restartTimer);
    _pageController.addListener(_finshTraining);
    //_pageController.addListener(_doScroll);
    /*
    if (animationStateNotifier.scrollPageState == true && _pageController.page.toInt() != widget.artboardList.length-1) {
      setState(() {
        _pageController.jumpToPage(_pageController.page.toInt() + 1);
      });

    }
    */


    //..addListener(_onScrollUpDateAnimation);
    /*
    _showCheckAnimation = false;
    _previousPage = _pageController.initialPage;
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: _durations[_pageIndex])
    );
    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward();
        //_animationController.duration = Duration(seconds: 5);
        //artboardMap[_pageController.page.round()].animationByName('Animation 1').reset();
        //final Artboard _riveBoard = artboardMap[_pageController.page.round()];
        //_riveBoard.animationByName('Animation 1').reset();
        //artboardMap[_pageController.page.round()] = _riveBoard;
        // Rive change
        //_riveArtboard.animationByName('Animation 1').reset();
        //log('${_riveArtboard.animationByName('Animation 1').lastTotalTime}');
        //_controller1 = SimpleAnimation(_riveArtboard.animations[_pageController.page.round()+1].name);
        //_riveArtboard.removeController(_controller);
        //_riveArtboard.addController(_controller1);

        //_pageController.jumpToPage(_pageController.page.round()+1);

        //_togglePlay();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.isDismissed;
      }
    });
    */

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.


    //_initRiveAnimation();




  }

  void _doScroll() {
    final AnimationStateNotifier animationStateNotifier = Provider.of<AnimationStateNotifier>(context, listen: false);
    print('Hallooooooo');
    if (animationStateNotifier.scrollPage == true) {
      print('bin drin');
      print('${_pageController.page.toInt()}');
      animationStateNotifier.updatePage(false);
      _pageController.jumpToPage(_pageController.page.toInt() + 1);
    }
  }



  void _onScrollUpDateAnimation() {
    if (_pageController.page.toInt() < _previousPage || _pageController.page.toInt() > _previousPage) {
      _previousPage = _pageController.page.toInt();
      log('prevousPage: $_previousPage');
      _animationController.dispose();
      _animationController = AnimationController(
          vsync: this,
          duration: Duration(seconds: _durations[_previousPage])
      );
      _animationController.forward();

    }

  }


  void _onScroll() {
    if (_pageController.page.toInt() == _pageController.page) {
      _previousPage = _pageController.page.toInt();
    }
    _notifier?.value = _pageController.page - _previousPage;
    log('pagecontrollerPage: ${_pageController.page.toInt()}');
    //log('notifyer: ${_notifier?.value}');
  }

  void _finshTraining() {
    if (_setCounter == widget.sets && _pageController.page.toInt() == widget.artboardList.length-1) {
      Future.delayed(Duration(seconds: widget.trainingSeconds + widget.pauseSeconds), () {
        setState(() {
          _finish = true;
        });
      });
    }
  }

  void _restartTimer() {
    final AnimationStateNotifier animationStateNotifier = Provider.of<AnimationStateNotifier>(context, listen: false);
    _timer.cancel();
    _pageIndex = _pageController.page.toInt();
    setState(() {
      _timer = Timer.periodic(Duration(seconds: widget.trainingSeconds + widget.pauseSeconds + 2), (Timer timer) {
        if (_pageIndex < widget.artboardList.length-1) {
          _pageIndex++;
        } else {
          if (_setCounter < widget.sets) {
            animationStateNotifier.holdAnimationValues(_pageIndex, 0.0);
            animationStateNotifier.updateAnimationState(_pageIndex, true);
            _pageIndex = 0;
            _setCounter++;
          } else {
            _pageIndex =_pageIndex;
          }

        }

        _pageController.animateToPage(
          _pageIndex,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      });
    });
  }



  @override
  void dispose() {
    //_animationController.removeListener(_togglePlay);
    //_animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.artboardList.length,
            itemBuilder: (context, position) {

              //final _artboard = artboardMap[position];
              //print('im build: ${_artboard}');
              //print(animationControllerMap[position]);
              //_reinitRiveAnimation(position);
              return Consumer<AnimationStateNotifier>(
                  builder: (context, data, child) {
                    if (position == widget.artboardList.length-1) {
                      _nextArtBoardIndex = 0;
                    } else {
                      _nextArtBoardIndex = position + 1;
                    }
                    if (_finish == true) {
                      return FinishAnimation(routine: widget.routine, workout: widget.workout, artboard: widget.artboardList, muscle: widget.muscle, thumbnail: widget.thumbnail,
                        training: widget.trainingSeconds, sets: widget.sets, level: widget.level, pause: widget.pauseSeconds,);
                    } else {
                      return AnimationWidget(
                        duration: Duration(seconds: _durations[position]),
                        artBoardName: widget.artboardList[position],
                        nextArtBoardName: widget.artboardList[_nextArtBoardIndex],
                        showCheckAnimation: false,//data.animationState()[position],
                        lastAnimationValue: data.animationValue()[position],
                        page: position,
                        trainingSeconds: widget.trainingSeconds,
                        pauseSeconds: widget.pauseSeconds,
                        workout: widget.workout[position],
                        workoutNext: widget.workout[_nextArtBoardIndex],
                        workoutLength: widget.artboardList.length,
                        sets: widget.sets,
                        currentSet: _setCounter,
                      );
                    }

                  }
              );

            }
        )


    );
  }
}