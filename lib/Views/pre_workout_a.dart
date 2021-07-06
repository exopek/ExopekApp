

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/Notifyers/animationState_notifyer.dart';
import 'package:video_app/Notifyers/timerEnd_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/rive_animation_a.dart';

class PreWorkoutPage extends StatefulWidget {

  final List artboardList;
  final int trainingSeconds;
  final int pauseSeconds;
  final int sets;
  final List workout;
  final String routine;
  final List thumbnail;
  final List muscle;
  final List level;
  final uid;

  const PreWorkoutPage({Key key, this.artboardList, this.trainingSeconds, this.pauseSeconds, this.sets, this.workout, this.routine, this.thumbnail, this.muscle, this.level, this.uid}) : super(key: key);

  @override
  _PreWorkoutPageState createState() => _PreWorkoutPageState();
}

class _PreWorkoutPageState extends State<PreWorkoutPage> with SingleTickerProviderStateMixin {

  AnimationController _preAnimationController;
  bool _play;

  @override
  void initState() {
    super.initState();
    _play = true;
    _preAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10)
    );
    _preAnimationController.reverse(from: 10.0);
    _preAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.dismissed) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MultiProvider(
                  providers: [
                    Provider(create: (context) => DatabaseHandler(uid: widget.uid),),
                    ChangeNotifierProvider(create: (context) => TimerNotifyer()),
                    ChangeNotifierProvider(create: (context) => AnimationStateNotifier())
                  ], child: AnimationPage(artboardList: widget.artboardList, trainingSeconds: widget.trainingSeconds, pauseSeconds: widget.pauseSeconds, sets: widget.sets, workout: widget.workout, routine: widget.routine,
                thumbnail: widget.thumbnail, level: widget.level, muscle: widget.muscle,)//child: VideoPlayerList(urlList: videoPath, workoutName: widget.routineName, muscleGroupsList: muscleGroups, classifycationList: classifycation, thumbnialsList: thumbnails, workoutNameList: workout,),
              );

            },
          ),
        );
      }
    });
  }

  void _startTimer() {
    _preAnimationController.reverse(from:_preAnimationController.value);
  }

  void _pauseTimer() {
    _preAnimationController.stop();
  }

  @override
  void dispose() {
    _preAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: Text(
          'Gleich geht es los',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0
          ),
        ),
        centerTitle: true,
        leading: Container(),
        actions: [IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ]
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.2,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    'Lege deine Fitnessbänder an',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontFamily: 'FiraSansExtraCondensed'
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                  child: AnimatedBuilder(
                    animation: _preAnimationController,
                    builder: (BuildContext context, Widget child) {
                      final duration = _preAnimationController.duration * _preAnimationController.value;
                      return Text(
                        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 100.0,
                            fontWeight: FontWeight.bold
                        ),
                      );
                    },
                  ),
                ),
              ),
              Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
                      child: NeoContainer(
                        spreadRadius2: 0.0,
                        containerHeight: MediaQuery.of(context).size.height*0.12,
                        containerWidth: MediaQuery.of(context).size.height*0.12,
                        circleShape: true,
                        shadowColor2: Colors.white60,
                        shadowColor1: Colors.black,
                        gradientColor1: Theme.of(context).primaryColor,
                        gradientColor2: Theme.of(context).primaryColor,
                        gradientColor3: Theme.of(context).primaryColor,
                        gradientColor4: Theme.of(context).primaryColor,
                        containerChild: IconButton(
                          iconSize: 30.0,
                          onPressed: () {
                            if(_preAnimationController.isAnimating) {
                              setState(() {
                                _play = false;
                                _pauseTimer();
                              });
                            } else {
                              setState(() {
                                _play = true;
                                _startTimer();
                              });
                            }
                          },
                          icon: Icon(
                              _play ? Icons.play_arrow : Icons.pause,
                              color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.21, left: MediaQuery.of(context).size.width*0.7),
                    child: NeoContainer(
                      spreadRadius2: 0.0,
                      containerHeight: MediaQuery.of(context).size.height*0.1,
                      containerWidth: MediaQuery.of(context).size.height*0.1,
                      circleShape: true,
                      shadowColor2: Colors.white60,
                      shadowColor1: Colors.black,
                      gradientColor1: Theme.of(context).primaryColor,
                      gradientColor2: Theme.of(context).primaryColor,
                      gradientColor3: Theme.of(context).primaryColor,
                      gradientColor4: Theme.of(context).primaryColor,
                      containerChild: IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return MultiProvider(
                                      providers: [
                                        Provider(create: (context) => DatabaseHandler(uid: widget.uid),),
                                        ChangeNotifierProvider(create: (context) => TimerNotifyer()),
                                        ChangeNotifierProvider(create: (context) => AnimationStateNotifier())
                                      ], child: AnimationPage(artboardList: widget.artboardList, trainingSeconds: widget.trainingSeconds, pauseSeconds: widget.pauseSeconds, sets: widget.sets, workout: widget.workout, routine: widget.routine,
                                    thumbnail: widget.thumbnail, level: widget.level, muscle: widget.muscle,)//child: VideoPlayerList(urlList: videoPath, workoutName: widget.routineName, muscleGroupsList: muscleGroups, classifycationList: classifycation, thumbnialsList: thumbnails, workoutNameList: workout,),
                                  );

                                },
                              ),
                            );
                          }),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
