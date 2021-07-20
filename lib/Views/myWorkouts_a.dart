import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/add_routine_button.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/trueOrfalse_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/editMyWorkouts_a.dart';

class MyWorkoutsAPage extends StatefulWidget {
  @override
  _MyWorkoutsAPageState createState() => _MyWorkoutsAPageState();
}

class _MyWorkoutsAPageState extends State<MyWorkoutsAPage> with SingleTickerProviderStateMixin {

  PageController _pageViewController1;

  double viewportFraction = 0.8;

  double pageOffset = 0.0;

  StreamController<dynamic> _infoIndexController;

  Stream myWorkoutInfoStream;

  int _infoState;

  int _currentPage;

  @override
  void initState() {
    _infoState  = 0;
    _currentPage = 0;
    _infoIndexController = StreamController<dynamic>();
    myWorkoutInfoStream = _infoIndexController.stream.asBroadcastStream();
    _pageViewController1 = PageController(initialPage: 0, viewportFraction: viewportFraction)
      ..addListener(() {
        setState(() {
          pageOffset = _pageViewController1.page;
          _currentPage = _pageViewController1.page.toInt();
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
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Meine Workouts',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        leading: Container(),
      ),
      body: StreamBuilder<List<RoutineAnimation>>(
        stream: database.routineStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.requireData.isNotEmpty) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 10.0,
                            width: 80.0,
                            color: Colors.red,
                          ),
                          AddRoutineButton(),
                          Container(
                            height: 10.0,
                            width: 80.0,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                    _workouts(context, snapshot),
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: _infoSideBar(context, snapshot)
                    ),
                  ] ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 8,
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 10.0,
                            width: 80.0,
                            color: Colors.red,
                          ),
                          AddRoutineButton(),
                          Container(
                            height: 10.0,
                            width: 80.0,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.6,
                      //color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Align(
                          child: Text('Du hast noch kein Workout erstellst?\n'
                              'Über das Klicken auf das + Symbol erstellst du dein erstes Workout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontFamily: 'FiraSansExtraCondensed'
                            ),
                          ),
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    )

                  ] ),
            );
          }
          /*
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                    if (snapshot.hasData && snapshot.requireData.isNotEmpty) {
                      return SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 10.0,
                                      width: 80.0,
                                      color: Colors.red,
                                    ),
                                    AddRoutineButton(),
                                   Container(
                                     height: 10.0,
                                     width: 80.0,
                                     color: Colors.red,
                                   )
                                  ],
                                ),
                              ),
                              _workouts(context, snapshot),
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: _infoSideBar(context, snapshot)
                              ),
                            ] ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 8,
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 10.0,
                                      width: 80.0,
                                      color: Colors.red,
                                    ),
                                    AddRoutineButton(),
                                    Container(
                                      height: 10.0,
                                      width: 80.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.6,
                                //color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Align(
                                    child: Text('Du hast noch kein Workout erstellst?\n'
                                        'Über das Klicken auf das + Symbol erstellst du dein erstes Workout',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      fontFamily: 'FiraSansExtraCondensed'
                                    ),
                                    ),
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                              )

                            ] ),
                      );
                    }




              ],
            ),
          );
          */
        }
      ),
    );
  }

  Widget _workouts(BuildContext context, snapshot) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      height:  MediaQuery.of(context).size.height/4,
      //width: MediaQuery.of(context).size.width,
      child: PageView.builder(
              onPageChanged: (context) {
                if (_pageViewController1.page == null) {
                  return _infoIndexController.add(0);
                } else {
                  return _infoIndexController.add(_pageViewController1.page.round());
                }
              },
                controller: _pageViewController1,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  double scale = max(viewportFraction ,(1-(pageOffset - index).abs()) + viewportFraction);
                  return _workoutsContainer(context, index, scale, snapshot.data[index].routine);
                })
    );
  }

  Widget _workoutsContainer(BuildContext context, index, scale, String name) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Padding(
      padding: EdgeInsets.only(top: 50 - scale * 25, bottom: 10,
      left: 10, right: 10),
      child: NeoContainer(
        containerHeight: MediaQuery.of(context).size.height/3,
        containerWidth: MediaQuery.of(context).size.width,
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
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.17),
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
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.04, left: MediaQuery.of(context).size.width*0.03, right: MediaQuery.of(context).size.width*0.24),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(name.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'FiraSansExtraCondensed',
                  color: Colors.white,
                  fontSize: 25.0
                )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width*0.2,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        primary: Colors.grey,
                        side: BorderSide(color: Colors.white)
                    ),
                    child: Center(
                      child: Icon(
                          Icons.delete,
                          color: Colors.white
                      ),
                    ),
                    // Gesamtes erstellte Routine wird gelöscht
                    onPressed: () {

                      setState(() {
                        database.deleteRoutine(name);
                        _pageViewController1.jumpToPage(0);
                      });
                    }
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width*0.2,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.grey,
                      side: BorderSide(color: Colors.white)
                    ),
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
                                  ChangeNotifierProvider(create: (context) => TrueOrFalseNotifyer()),
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

  Widget _infoSideBar(BuildContext context, snapshot) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      height: 100.0*snapshot.data[_currentPage].workout.length,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.white,
                        ),
                        itemCount: snapshot.data[_currentPage].workout.length,
                        itemBuilder: (context, adex) {
                          print('------------------------');
                          //print(snapshot.data[_infoState].workoutNames.first);
                          // ToDo: Bug -> Beschreibung in Trello
                          if (snapshot.data[_currentPage].workout == null) {
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
                                width: MediaQuery.of(context).size.width,
                                height: 80.0,
                                child: Center(
                                    child: Text(snapshot.data[_currentPage].workout[adex],
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
                      )
    );
  }
}
