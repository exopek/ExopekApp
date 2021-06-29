import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:video_app/CustomWidgets/workout_completion_ring.dart';
import 'package:video_app/Notifyers/animationState_notifyer.dart';

class AnimationWidget extends StatefulWidget {
  const AnimationWidget({Key key, this.duration, this.artBoardName, this.showCheckAnimation, this.page, this.lastAnimationValue, this.trainingSeconds, this.pauseSeconds, this.workout, this.position, this.workoutLength, this.nextArtBoardName}) : super(key: key);

  final Duration duration;
  final String artBoardName;
  final String nextArtBoardName;
  final bool showCheckAnimation;
  final int page;
  final double lastAnimationValue;
  final int trainingSeconds;
  final int pauseSeconds;
  final String workout;
  final int position;
  final int workoutLength;

  @override
  _AnimationWidgetState createState() => _AnimationWidgetState();
}


class _AnimationWidgetState extends State<AnimationWidget> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  RiveAnimationController _controller;
  RiveAnimationController _controllerNext;
  Artboard _riveArtboard;
  Artboard _riveArtboardNext;
  bool _showCheckAnimation;
  double _lastAnimationVaue;
  Color _animationColor;
  String _workoutState;

  @override
  void initState() {
    super.initState();
    _workoutState = 'Training';
    _animationColor = Colors.green;
    _lastAnimationVaue = widget.lastAnimationValue;
    _showCheckAnimation = widget.showCheckAnimation;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animationController.forward(from: _showCheckAnimation ? 1.0 : _lastAnimationVaue);
    _animationController.addStatusListener((status) {
      final AnimationStateNotifier animationStateNotifier = Provider.of<AnimationStateNotifier>(context, listen: false);
      if (status == AnimationStatus.completed) {
        _showCheckAnimation = true;
        animationStateNotifier.updateAnimationState(widget.page, true);
        _controller.isActive = false;
        animationStateNotifier.updatePage(true);

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _animationController
              ..duration = Duration(seconds: widget.pauseSeconds);
            log('position: ${widget.page} - workoutLength: ${widget.workoutLength}');
            if (widget.page == widget.workoutLength-1) {
              _animationColor = Colors.green;
              _workoutState = 'Fertig';
              _animationController.reset();
            } else {
              _animationColor = Colors.lightBlue[400];
              _workoutState = 'Pause';
              _animationController.animateBack(0);
            }

          });


        });

      } else if (status == AnimationStatus.dismissed) {
        log('animationControllerValue: ${_animationController.value}');
        animationStateNotifier.holdAnimationValues(widget.page, _animationController.value);
        //_controller.isActive = false;
      }
    });
    rootBundle.load('assets/kniebeuge.riv').then(
          (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
          // _artBoardList wird über ein Future geladen
          final _riveBoard = file.artboardByName(widget.artBoardName);
          final _riveBoardNext = file.artboardByName(widget.nextArtBoardName);
          _controller = SimpleAnimation('Animation 1');
          _controllerNext = SimpleAnimation('Animation 1');
          _riveBoard.addController(_controller);
          _riveBoardNext.addController(_controllerNext);
           setState(() {
             _riveArtboard = _riveBoard;
             _riveArtboardNext = _riveBoardNext;
           });

      },
    );

  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _controllerNext.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.duration = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    final AnimationStateNotifier animationStateNotifier = Provider.of<AnimationStateNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _animationColor,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/16,
              width: MediaQuery.of(context).size.width,
              color: _animationColor,
              child: Center(
                child: Text(_workoutState,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/6,
              width: MediaQuery.of(context).size.width,
              color: _animationColor,
              child: Center(
                child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (BuildContext context, Widget child) {
                      Duration dur = _animationController.duration * _animationController.value;
                      return Text(
                        '${dur.inMinutes}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 100.0,
                          fontWeight: FontWeight.bold
                        ),
                      );
                    }
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/3,

              color: Theme.of(context).primaryColor,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _lastAnimationVaue = 0.0;
                    _showCheckAnimation = false;
                    _controller.isActive = true;
                    _animationController.reset();
                    _animationController.forward(from: 0.0);
                    animationStateNotifier.holdAnimationValues(widget.page, _lastAnimationVaue);
                    animationStateNotifier.updateAnimationState(widget.page, false);
                  });
                },
                    child: Container(
                      height: MediaQuery.of(context).size.height/3,
                      width: MediaQuery.of(context).size.width/2,
                      child: AnimatedBuilder(
                          animation:  _animationController,
                          builder: (BuildContext context, Widget child) {
                            final progress = _animationController.value ?? 0;
                            if (mounted) {
                              animationStateNotifier.holdAnimationValues(widget.page, progress);
                            }
                            return Stack(
                              children: [
                                Center(child: WorkoutCompletionRing(progress: progress,)),
                                _showCheckAnimation ? Center(
                                  child: Container(
                                      height: 150.0,
                                      width: 150.0,
                                      child: Rive(artboard: _riveArtboardNext,
                                      )
                                  ),
                                )
                            /*
                            Positioned.fill(
                                  child: Image.asset('assets/Logo_weiß.png'
                                  )
                                )
                                    */
                                    :
                                Center(
                                  child: Container(
                                      height: 150.0,
                                      width: 150.0,
                                      child: Rive(artboard: _riveArtboard,
                                      )
                                  ),
                                )
                              ],
                            );
                          }
                      ),
                    ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/16,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(widget.workout,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
