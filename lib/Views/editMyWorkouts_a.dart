import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/DraggableListItem.dart';
import 'package:video_app/CustomWidgets/persistant_sliver_header.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/categoryTabBarIndex.dart';
import 'package:video_app/Notifyers/color_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/category_a.dart';
import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditWorkoutPage extends StatefulWidget {

  final routineName;

  const EditWorkoutPage({Key key,@required this.routineName}) : super(key: key);

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {

  //List<dynamic> routineInput;
  RoutineAnimation routineInput;

  List workoutList;

  RoutineAnimation routineMap;

  Future<RoutineAnimation> getWorkoutList(BuildContext context) async {
          final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
          try {
            final Input = await database.getRoutineCustomMap(widget.routineName);
            log('pureInput: $Input');
            routineInput = Input;
            log('input: $Input');
          } catch(e) {
            print(e);
          }
          return routineInput;
  }

  bool firstVisit;

  @override
  void initState() {
    firstVisit = false;
    workoutList = new List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);

    if (firstVisit == false) {
      getWorkoutList(context).then((value){
        setState(() {
          //workoutList = value;
          routineMap = value;
          log('routineMap: $routineMap');
          firstVisit = true;
        });
      });

    }
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        top: false,
          child: CustomScrollView(
            slivers:[
              SliverPersistentHeader(
                pinned: true, // header bleibt fest bei minExtent
                //floating: true,     // Scrollt den gesamten header weg
                delegate: NetworkingPageHeader(
                  expandPic: false,
                    showBackButton: true,
                    minExtent: MediaQuery.of(context).size.height*0.3,
                    maxExtent: MediaQuery.of(context).size.height*0.4,
                    headerName: widget.routineName,
                    picRef: 'assets/Exopek_Logo.png'
                    //headerText: 'Füge Übungen hinzu\nund baue somit dein ganz persönliches Workout'
                ),
              ),
              /*
              SliverList(

                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Column(
                      children: [
                        _excerciseDragandDrop(context),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                _createRoute(context)
                            );
                          },
                          child: Center(
                            child: Icon(
                                Icons.add,
                                color: Colors.white,
                            ),
                          ),
                        ),

                      ],
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              */
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: [
                       Align(
                          alignment: Alignment.centerRight,
                            child: _excerciseDragandDrop(context)),
                      IconButton(
                        splashColor: Colors.grey,
                        onPressed: () {
                          Navigator.of(context).push(
                              _createRoute(context)
                          );
                        },
                        icon: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        iconSize: 30.0,
                      ),

                    ],
                  ),
                ),
              )
            ]
          )),
    );
  }

  Widget _listPoints(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.45,
      width: MediaQuery.of(context).size.width*1/3,
      color: Colors.red,
      child: ListView(
          scrollDirection: Axis.vertical,
        children: [
          if (routineMap.workout.isNotEmpty)
            for (int i = 0; i <= routineMap.workout.length-1; i++)
              Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange
                ),
              )
        ]
      ),
    );
  }

  Widget _excerciseDragandDrop(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return FutureBuilder<RoutineAnimation>(
      future: getWorkoutList(context),
      builder: (context, snapshot) {
        return Container(
          height: MediaQuery.of(context).size.height/1.45,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: ReorderableListView(
            //scrollController: ScrollController().,
            //physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              if (snapshot.hasData)
                for (int i = 0; i <= routineMap.workout.length-1; i++)
                     Slidable(
                       key: ValueKey(i.toString()),
                       actionPane: SlidableScrollActionPane(),
                       actionExtentRatio: 1,
                       secondaryActions: <Widget> [
                         IconSlideAction(
                           caption: 'Löschen',
                           color: Colors.red,
                           icon: Icons.delete,
                           onTap: () {
                             routineMap.workout.removeAt(i);
                             routineMap.thumbnail.removeAt(i);
                             routineMap.artboard.removeAt(i);
                             routineMap.level.removeAt(i);
                             routineMap.muscle.removeAt(i);
                             routineMap = routineMap;
                             database.updateRoutineWorkoutList(routineMap, widget.routineName);
                             setState(() {

                             });
                             log('index: $i');
                           },
                         )
                       ],
                       child: DraggableWidget(
                        key: ValueKey(i.toString()),
                        customWidgetString: routineMap.workout[i],
                         workoutLocation: i.toString(),
                    ),
                     ),

            ],
            onReorder: (oldIndex, newIndex) {
              setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final workouts = routineMap.workout.removeAt(oldIndex);
              //print(workout);
              routineMap.workout.insert(newIndex, workouts);
              // Anderer Datensatz
              final thumbs = routineMap.thumbnail.removeAt(oldIndex);
              routineMap.thumbnail.insert(newIndex, thumbs);
              // Anderer Datensatz
              final arts = routineMap.artboard.removeAt(oldIndex);
              routineMap.artboard.insert(newIndex, arts);
              // Anderer Datensatz
              final classy = routineMap.level.removeAt(oldIndex);
              routineMap.level.insert(newIndex, classy);
              // Anderer Datensatz
              final muscleG = routineMap.muscle.removeAt(oldIndex);
              routineMap.muscle.insert(newIndex, muscleG);

                //workoutList = workoutList;
              routineMap = routineMap;
                database.updateRoutineWorkoutList(routineMap, widget.routineName);
              });
            },
          ),
        );
      }
    );
  }

  Widget _excercises(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      height: MediaQuery.of(context).size.height/5,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/5,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<Routine>(
                stream: database.routineInputStream(widget.routineName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.workoutNames.length,
                      itemBuilder: (context, adex) {
                        print(snapshot.data);
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Material(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            elevation: 5.0,
                            child: Container(
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.width/3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  child: Stack(
                                      children:[
                                        Image(
                                            image: NetworkImage(snapshot.data.thumbnails[adex]),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        Text(snapshot.data.workoutNames[adex]),
                                      ]
                                  )
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(color: Colors.black,);
                  }
                }
            ),
          )
        ],
      ),
    );
  }

  Route _createRoute(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context, listen: false);
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return MultiProvider(
            providers: [
              Provider(create: (context) => DatabaseHandler(uid: database.uid),),
              ChangeNotifierProvider(create: (context) => ColorNotifyer(context: context)),
              ChangeNotifierProvider(create: (context) => CTabBarIndex(context: context)),
            ],
            child: CategoryAPage(category: 'Konfigurator', routineName: widget.routineName,));
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
