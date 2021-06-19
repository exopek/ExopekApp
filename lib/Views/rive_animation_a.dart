import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:video_app/CustomWidgets/animationWidget.dart';
import 'package:video_app/Notifyers/animationState_notifyer.dart';


class AnimationPage extends StatefulWidget {

  final List artboardList;

  const AnimationPage({Key key, this.artboardList}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
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
  //List _artBoardList = ['Art', 'Art1', 'Art2', 'Art3'];
  List _durations = [10, 5, 20, 10];
  //var _animationState = new List.filled(3, false);


  int _pageIndex;
  double viewportFraction = 0.0;
  PageController _pageController;
  bool _showCheckAnimation;
  int _animationList_length;
  var artboardMap = new Map();
  Map<int, Animation> animationControllerMap = {};
  AnimationController _animationController;
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  RiveAnimationController _controller1;
  RiveAnimationController _controller2;
  List<RiveAnimationController> _riveController = [];
  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pageController = PageController(
      initialPage: 0);
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

  /*
  void _reinitRiveAnimation(int pageIndex) {
    rootBundle.load('assets/kniebeuge.riv').then(
          (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        for (int i = 0; i < file.artboards.length; i++) {
          // _artBoardList wird über ein Future geladen
          RiveAnimationController _testcontroller;
          _testcontroller = SimpleAnimation('Animation 1');
          /*
          final _animationController = AnimationController(
              vsync: this,
              duration: Duration(seconds: _durations[i])
          );
          */
          final _riveBoard = file.artboardByName(_artBoardList[i]);
          //_riveBoard.animations[0].context.fills.first;
          final _controller = SimpleAnimation('Animation 1');
          _riveBoard.addController(_controller);
          log('pageIndex: $pageIndex');
          if (i == pageIndex) {
            _controller.isActive = true;
            _animationController.notifyStatusListeners(AnimationStatus.completed);
            //_animationController.forward();
          } else {
            _controller.isActive = false;
            _animationController.notifyStatusListeners(AnimationStatus.dismissed);
            //_animationController.stop();
          }
          //final animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
          //animationControllerMap[i] = animation;
          artboardMap[i] = _riveBoard;
          //log('artBoard: $artboardMap');
        }

        log('mapArt: $artboardMap');
      },
    );
  }
  */


  /*
    void _initRiveAnimation() {
      rootBundle.load('assets/kniebeuge.riv').then(
            (data) async {
          // Load the RiveFile from the binary data.
          final file = RiveFile.import(data);
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          //
          // final artboard = file.mainArtboard;
          final _controller = SimpleAnimation('Animation 1');
          /*
          _controller1 = SimpleAnimation('Animation 1');
          _controller2 = SimpleAnimation('Animation 1');
          final _riveBoard = file.artboardByName(_artBoardList[0]);
          final _riveBoard1 = file.artboardByName(_artBoardList[1]);
          final _riveBoard2 = file.artboardByName(_artBoardList[2]);
          _riveBoard.addController(_controller);
          _riveBoard1.addController(_controller1);
          _riveBoard2.addController(_controller2);
          artboardMap[0] = _riveBoard;
          artboardMap[1] = _riveBoard1;
          artboardMap[2] = _riveBoard2;
          */

          for (int i = 0; i < file.artboards.length; i++) {
            // _artBoardList wird über ein Future geladen
            RiveAnimationController _testcontroller;
            _testcontroller = SimpleAnimation('Animation 1');

            final _riveBoard = file.artboardByName(_artBoardList[i]);
            //_riveBoard.animations[0].context.fills.first;

            //_riveBoard.animationByName('Animation 1').animation.context.fills.first;
            //_riveBoard.fills.first;
            final _controller = SimpleAnimation('Animation 1');
            _riveBoard.addController(_controller);
            if (i == 0) {
              _controller.isActive = true;
            } else {
              _controller.isActive = false;
            }

            artboardMap[i] = _riveBoard;
            log('artBoard: $artboardMap');
          }

          //log('artboard.animations[0]: ${artboard.animations[2].name}');
          //log('animations_length: ${artboard.animations.length}');

          //final animations_map = artboard.animations.asMap();


          //artboard.addController(_controller);


          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          /*
        for (int i = 0; i < artboard.animations.length; i++) {
          artboard.animations[i].context.fills.first;
          artboard.removeController(_controller);

          artboard.addController();
          artboardMap[i] = artboard;

        }
        */
          log('mapArt: $artboardMap');
          setState(() {
            //_riveArtboard = artboard;
          });
        },
      );
    }
    */

    @override
    void dispose() {
    //_animationController.removeListener(_togglePlay);
    //_animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
      ),
      body: PageView.builder(
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
                  return AnimationWidget(
                    duration: Duration(seconds: _durations[position]),
                    artBoardName: widget.artboardList[position],
                    showCheckAnimation: data.animationState()[position],
                    lastAnimationValue: data.animationValue()[position],
                    page: position,
                  );
                }
                );


                  /*
                  Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width/2,
                      //color: Color.fromRGBO(70*_pageController.page.round(), 0, 0, 1),
                      child: AnimatedBuilder(
                        animation:  _animationController,
                        builder: (BuildContext context, Widget child) {
                          final progress = _animationController.value ?? 0;
                          final hasCompleted = progress == 1.0;

                          return Stack(
                            children: [
                              Center(child: WorkoutCompletionRing(progress: progress,)),
                              _showCheckAnimation ? Positioned.fill(
                                child: Icon(
                                  Icons.timer,
                                  color: Colors.green,
                                ),
                              ) :
                               Rive(artboard: artboardMap[position],)
                            ],
                          );
                        }
                      ),
                    ),
                  ),
                );
                */
              }
            ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      */
    );
  }
}