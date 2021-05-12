import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/add_routine_button.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/infoTextRoutine_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/editMyWorkouts_a.dart';

class MyWorkoutsAPage extends StatefulWidget {
  @override
  _MyWorkoutsAPageState createState() => _MyWorkoutsAPageState();
}

class _MyWorkoutsAPageState extends State<MyWorkoutsAPage> {

  PageController _pageViewController1;

  double viewportFraction = 0.2;

  double pageOffset = 0.0;

  StreamController<dynamic> _infoIndexController;

  Stream myWorkoutInfoStream;

  int _infoState;

  @override
  void initState() {
    _infoState  = 0;
    _infoIndexController = StreamController<dynamic>();
    myWorkoutInfoStream = _infoIndexController.stream.asBroadcastStream();
    _pageViewController1 = PageController(initialPage: 0, viewportFraction: viewportFraction)
      ..addListener(() {
        setState(() {
          pageOffset = _pageViewController1.page;
        });
      });
    _infoIndexController.stream.listen((event) {
      setState(() {
        _infoState = event;
      });
    });
    super.initState();
  }


  void dispose() {
    _infoIndexController.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text('My Workouts'),
        leading: Container(),
      ),
      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Stack(children: [
          _workouts(context),
          Padding(
            padding: EdgeInsets.only(left: 200),
            child: _infoSideBar(context)
          ),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/1.6, top: MediaQuery.of(context).size.height/1.35,right: 10.0),
            child: AddRoutineButton(),
          )
        ] ),
      ),
    );
  }

  Widget _workouts(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      height:  MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width/2,
      child: StreamBuilder<List<Routine>>(
        stream: database.routineStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PageView.builder(
              onPageChanged: (context) {
                if (_pageViewController1.page == null) {
                  return _infoIndexController.add(0);
                } else {
                  return _infoIndexController.add(_pageViewController1.page.round());
                }
              },
                controller: _pageViewController1,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  double scale = max(viewportFraction ,(1-(pageOffset - index).abs()) + viewportFraction);
                  return _workoutsContainer(context, index, scale, snapshot.data[index].routineName);
                });
          } else {
            return Container();
          }

        }
      ),
    );
  }

  Widget _workoutsContainer(BuildContext context, index, scale, String name) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10,
      left: 10, right: 50 - scale * 25),
      child: NeoContainer(
        containerHeight: MediaQuery.of(context).size.height/3,
        containerWidth: MediaQuery.of(context).size.width/2,
        containerBorderRadius: BorderRadius.all(Radius.circular(15.0)),
        circleShape: false,
        shadowColor2: Colors.grey,
        shadowColor1: Colors.black,
        gradientColor1: Theme.of(context).primaryColor,
        gradientColor2: Theme.of(context).primaryColor,
        gradientColor3: Theme.of(context).primaryColor,
        gradientColor4: Theme.of(context).primaryColor,
        containerChild: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: MediaQuery.of(context).size.height/10,
                  width: MediaQuery.of(context).size.height/60,
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0, left: 8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(name.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'FiraSansExtraCondensed',
                  color: Colors.white
                )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 50,
                  width: 50,
                  child: OutlineButton(
                    borderSide: BorderSide(
                      color: Colors.white
                    ),
                    color: Colors.grey,
                    splashColor: Colors.grey,
                    highlightElevation: 5.0,
                    highlightedBorderColor: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white
                      ),
                    ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MultiProvider(
                                providers: [
                                  Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                                ],
                                child: EditWorkoutPage(routineName: name,));
                          },
                        ),
                      ),
                  ),
                ),
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget _infoSideBar(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      height: MediaQuery.of(context).size.height/1.4,
      width: MediaQuery.of(context).size.width/2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Text('Übersicht',
            style: TextStyle(
              fontFamily: 'FiraSansExtraCondensed',
              fontSize: 30.0,
              color: Colors.white.withOpacity(0.86)
            ),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: NeoContainer(
              containerHeight: MediaQuery.of(context).size.height/1.6,
              containerWidth: MediaQuery.of(context).size.width/2,
              containerBorderRadius: BorderRadius.all(Radius.circular(15.0)),
              circleShape: false,
              shadowColor2: Colors.grey,
              shadowColor1: Colors.black,
              gradientColor1: Theme.of(context).primaryColor,
              gradientColor2: Theme.of(context).primaryColor,
              gradientColor3: Theme.of(context).primaryColor,
              gradientColor4: Theme.of(context).primaryColor,
              containerChild: StreamBuilder<List<Routine>>(
                stream: database.routineStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: snapshot.data[_infoState].workoutNames.length,
                      itemBuilder: (context, adex) {
                        print('------------------------');
                        //print(snapshot.data[_infoState].workoutNames.first);
                        // ToDo: Bug -> Beschreibung in Trello
                        if (snapshot.data[_infoState].workoutNames == null) {
                          return Container(
                            color: Colors.transparent,
                            height: 60.0,
                            child: Center(
                              child: Text(
                                'Erstelle dir dein eigenes Workout',
                                style: TextStyle(
                                    fontFamily: 'FiraSansExtraCondensed',
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                              color: Colors.transparent,
                              height: 60.0,
                              child: Center(
                                  child: Text(snapshot.data[_infoState].workoutNames[adex],
                                    style: TextStyle(
                                        fontFamily: 'FiraSansExtraCondensed',
                                        fontSize: 20.0,
                                        color: Colors.white.withOpacity(0.86)
                                    ),
                                  )
                              )
                          );
                        }
                        return Container(
                          color: Colors.transparent,
                            height: 60.0,
                            child: Center(
                                child: Text(snapshot.data[_infoState].workoutNames[adex],
                                style: TextStyle(
                                    fontFamily: 'FiraSansExtraCondensed',
                                    fontSize: 20.0,
                                  color: Colors.white.withOpacity(0.86)
                                ),
                                )
                            )
                        );
                      },
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Text(
                          'Erstelle dir dein eigenes Workout',
                          style: TextStyle(
                            fontFamily: 'FiraSansExtraCondensed',
                            fontSize: 25.0
                          ),
                        ),
                      ),
                    );
                  }
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}
