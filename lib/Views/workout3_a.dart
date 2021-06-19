import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/persistant_sliver_header.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/animationState_notifyer.dart';
import 'package:video_app/Notifyers/timerEnd_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/rive_animation_a.dart';

class Workout3APage extends StatefulWidget {

  final routineName;

  final String category;

  const Workout3APage({Key key,@required this.routineName, @required this.category}) : super(key: key);

  @override
  _Workout3APageState createState() => _Workout3APageState();
}


class _Workout3APageState extends State<Workout3APage> {


  RoutineAnimation routine;

  List workout;
  List videoPath;
  List thumbnails;
  List classifycation;
  List muscleGroups;


  Future<RoutineAnimation> getWorkoutList(BuildContext context) async {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    try {
      if (widget.category == 'Functional') {
        final RoutineAnimation input = await database.getFunctionalWorkoutsMap(widget.routineName);
        routine = input;
      } else if (widget.category == 'Mobility') {
        final RoutineAnimation input = await database.getMobilityWorkoutsMap(widget.routineName);
        routine = input;
      } else if (widget.category == 'My Workouts') {
        final RoutineAnimation input = await database.getRoutineCustomMap(widget.routineName);
        log('$input');
        routine = input;
      }
    } catch(e) {
      print('------------Exception---------');
      print(e);
    }
    return routine;
  }

  bool firstVisit;

  @override
  void initState() {
    firstVisit = false;
    workout = [];
    videoPath = [];
    thumbnails = [];
    classifycation = [];
    muscleGroups = [];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    if (firstVisit == false) {
      getWorkoutList(context).then((value){
        setState(() {
          workout = value.workoutNames;
          videoPath = value.artboards;
          thumbnails = value.thumbnails;
          classifycation = value.classifycation;
          muscleGroups = value.muscleGroups;
          firstVisit = true;
        });
      });

    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()
        ),
        slivers: [
          SliverPersistentHeader(
            pinned: true, // header bleibt fest bei minExtent
            //floating: true,     // Scrollt den gesamten header weg
            delegate: NetworkingPageHeader(
              expandPic: true,
              showBackButton: true,
                minExtent: 250.0,
                maxExtent: MediaQuery.of(context).size.height,
                headerName: widget.routineName
            ),
          ),
          /*
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height/1.02,
            //collapsedHeight: 100.0,
            //pinned: true,
            floating: true,
              backgroundColor: Theme.of(context).primaryColor,
            stretchTriggerOffset: 250.0,

            onStretchTrigger: () {
              return;
            },

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))
            ),
            elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                centerTitle: true,
                title: Text(widget.routineName,
                  style: TextStyle(
                      fontFamily: 'FiraSansExtraCondensed',
                      fontSize: 30.0,
                      color: Colors.black
                  ),),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://r-cf.bstatic.com/images/hotel/max1024x768/116/116281457.jpg',
                      fit: BoxFit.cover,
                    ),
                  ]
                ),
              )
          ),
          */
          SliverToBoxAdapter(
            child: Container(
              height: 100.0,
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 40.0,
                    width: 200.0,
                    color: Colors.red,
                    child: Center(
                      child: Text('Übersicht',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'FiraSansExtraCondensed',
                            fontSize: 22.0
                        ),),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Column(
                      children: [
                        Divider(
                          height: 0.5,
                          color: Colors.white,
                          thickness: 0.2,
                        ),
                        Container(
                          color: Theme.of(context).primaryColor,
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(workout[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontFamily: 'FiraSansExtraCondensed'
                              ),),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: workout.length
              )),
          SliverToBoxAdapter(
            //automaticallyImplyLeading: false,
            //actions: [
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.1,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MultiProvider(
                          providers: [
                            Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                            ChangeNotifierProvider(create: (context) => TimerNotifyer()),
                            ChangeNotifierProvider(create: (context) => AnimationStateNotifier())
                          ], child: AnimationPage(artboardList: videoPath)//child: VideoPlayerList(urlList: videoPath, workoutName: widget.routineName, muscleGroupsList: muscleGroups, classifycationList: classifycation, thumbnialsList: thumbnails, workoutNameList: workout,),
                        );

                      },
                    ),
                  ),
                  child: Center(
                    child: Text('Start'.toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'FiraSansExtraCondensed',
                          color: Colors.black,
                          fontSize: 25.0
                      ),),
                  ),
                ),
              )
            //],
          )
        ],
      ),
    );
  }


}


