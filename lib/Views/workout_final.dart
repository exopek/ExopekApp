import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/videoPlayer_withListView.dart';

//import '../videoplayerservice.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  PageController _pageViewControllerchest;
  PageController _pageViewControllerlegs;

  double viewportFraction = 0.8;

  double pageOffsetchest = 0.0;
  double pageOffsetlegs = 0.0;

  @override
  void initState() {
    _pageViewControllerchest = PageController(initialPage: 0, viewportFraction: viewportFraction)
      ..addListener(() {
        setState(() {
          pageOffsetchest = _pageViewControllerchest.page;
        });
      });
    _pageViewControllerlegs = PageController(initialPage: 0, viewportFraction: viewportFraction)
      ..addListener(() {
        setState(() {
          pageOffsetlegs = _pageViewControllerlegs.page;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[900],
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, top: MediaQuery.of(context).size.height/10),
              child: _header(context),
            ),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, top: MediaQuery.of(context).size.height/5),
              child: _chestWorkouts(context),
            ),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, top: MediaQuery.of(context).size.height/2),
              child: _legWorkouts(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Text('workouts'.toUpperCase(),
      style: TextStyle(
        fontFamily: 'FiraSansExtraCondensed',
        fontSize: 40.0,
        color: Colors.white
    ),);
  }

  Widget _chestWorkouts(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      height: MediaQuery.of(context).size.height/4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<WorkoutAnimation>>(
        stream: database.chestWorkoutStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return PageView.builder(
              controller: _pageViewControllerchest,
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int Index) {
                  double scale = max(viewportFraction ,(1-(pageOffsetchest - Index).abs()) + viewportFraction);
                    return _workoutContainerContent(context, snapshot.data[Index].workout, snapshot.data[Index].level,
                        snapshot.data[Index].bodyPart, snapshot.data[Index].thumbnail, snapshot.data[Index].artboardName, Index, scale);
                });
          } else {
            return PageView.builder(
              itemCount: 12,
                itemBuilder: (BuildContext context, int Index) {
                  double scale = max(viewportFraction ,(1-(pageOffsetchest - Index).abs()) + viewportFraction);
                return _waitContainer(context, Index, scale);
                });
          }
        },
      ),
    );
  }

  Widget _legWorkouts(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      height: MediaQuery.of(context).size.height/4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<WorkoutAnimation>>(
        stream: database.legWorkoutStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return PageView.builder(
                controller: _pageViewControllerlegs,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int Index) {
                  double scale = max(viewportFraction ,(1-(pageOffsetlegs - Index).abs()) + viewportFraction);
                  return _workoutContainerContent(context, snapshot.data[Index].workout, snapshot.data[Index].level,
                      snapshot.data[Index].bodyPart, snapshot.data[Index].thumbnail, snapshot.data[Index].artboardName, Index, scale);
                });
          } else {
            return PageView.builder(
                itemCount: 12,
                itemBuilder: (BuildContext context, int Index) {
                  double scale = max(viewportFraction ,(1-(pageOffsetlegs - Index).abs()) + viewportFraction);
                  return _waitContainer(context, Index, scale);
                });
          }
        },
      ),
    );
  }

  Widget _backWorkouts(BuildContext context) {
    return Container();
  }

  Widget _functionalWorkouts(BuildContext context) {
    return Container();
  }

  Widget _shoulderWorkouts(BuildContext context) {
    return Container();
  }

  Widget _waitContainer(BuildContext context, int index, double scale) {
    return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: 20.0,
                top: 50 - scale * 25,
                bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width/1.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0))
              ),
            ),
          ),
        ]
    );
  }

  Widget _workoutContainerContent(BuildContext context, String workout, String level, String bodyPart, String thumbnail, String videoUrl, int index, double scale) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: 20.0,
                top: 50 - scale * 25,
                bottom: 10),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return VideoPlayerList(urlList: [videoUrl]);
                  },
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width/1.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(thumbnail),
                        fit: BoxFit.fill
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(35.0))
                ),
              ),
            ),
          ),
        ]
    );
  }
}
