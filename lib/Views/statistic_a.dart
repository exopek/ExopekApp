import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/CustomWidgets/persistant_sliver_header.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/categoryTabBarIndex.dart';
import 'package:video_app/Notifyers/infoTextRoutine_notifyer.dart';
import 'package:video_app/Notifyers/listViewIndex.dart';
import 'package:video_app/Notifyers/navigationBar_notifyer.dart';
import 'package:video_app/Notifyers/sortBar_notifyer.dart';
import 'package:video_app/Notifyers/tabbar_color.dart';
import 'package:video_app/Notifyers/timerEnd_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Services/storage_handler.dart';
import 'package:video_app/Views/myWorkouts_a.dart';
import 'package:video_app/Views/videoPlayer2_a.dart';
import 'package:video_app/Views/videoPlayerChewie.dart';
import 'package:video_app/Views/videoPlayer_withListView.dart';
import 'package:video_app/videoplayerservice.dart';

import 'home_a.dart';

class StatisticAPage extends StatefulWidget {

  final routineName;

  final String category;

  const StatisticAPage({Key key, this.routineName, this.category}) : super(key: key);

  @override
  _StatisticAPageState createState() => _StatisticAPageState();
}


class _StatisticAPageState extends State<StatisticAPage> {


  Routine routine;

  List workout;

  List videoPath;

  var kraft;

  var ausdauer;

  var prozent_kraft;

  var prozent_ausdauer;

  Future<Routine> getWorkoutList(BuildContext context) async {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    try {
      if (widget.category == 'Functional') {
        final Routine Input = await database.getFunctionalWorkoutsMap(widget.routineName);
        routine = Input;
      } else if (widget.category == 'Mobility') {
        final Routine Input = await database.getMobilityWorkoutsMap(widget.routineName);
        routine = Input;
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
    kraft = 0;
    ausdauer = 0;
    prozent_kraft = 0;
    prozent_ausdauer = 0;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    /*
    if (firstVisit == false) {
      getWorkoutList(context).then((value){
        setState(() {
          workout = value.workoutNames;
          videoPath = value.videoPaths;
          firstVisit = true;
        });
      });

    }

     */
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      //bottomNavigationBar: _navigationBar(context),
      body: StreamBuilder<List<Einheit>>(
        stream: database.verlaufStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.length; i++) {
              if (snapshot.data[i].Klassifizierung[0] == 'Kraft') {
                kraft = kraft + 1;
              } else if (snapshot.data[i].Klassifizierung[0] == 'Ausdauer') {
                ausdauer = ausdauer + 1;
              }
            }
            prozent_kraft = (kraft/snapshot.data.length)*100;
            prozent_ausdauer = (ausdauer/snapshot.data.length)*100;
            print('proz_ausdauer: ${prozent_ausdauer}');
            return CustomScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
                SliverPersistentHeader(
                  pinned: true, // header bleibt fest bei minExtent
                  //floating: true,     // Scrollt den gesamten header weg
                  delegate: NetworkingPageHeader(
                      minExtent: 100.0,
                      maxExtent: MediaQuery.of(context).size.height/3,
                      headerName: 'Verlauf',
                      picRef: 'assets/Logo_weiß.png'
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NeoContainer(
                            gradientColor1: Theme.of(context).primaryColor,
                            gradientColor2: Theme.of(context).primaryColor,
                            gradientColor3: Theme.of(context).primaryColor,
                            gradientColor4: Theme.of(context).primaryColor,
                            containerHeight: MediaQuery.of(context).size.height/20,
                            containerWidth: MediaQuery.of(context).size.width/5,
                            shadowColor1: Colors.white30,
                            shadowColor2: Colors.black,
                            shadow2Offset: 1.0,
                            shadow1Offset: -1.0,
                            spreadRadius1: 1.0,
                            spreadRadius2: 2.0,
                            blurRadius1: 3.0,
                            blurRadius2: 3.0,
                            circleShape: false,
                            containerBorderRadius: BorderRadius.all(Radius.circular(40.0)),),
                          NeoContainer(
                            gradientColor1: Theme.of(context).primaryColor,
                            gradientColor2: Theme.of(context).primaryColor,
                            gradientColor3: Theme.of(context).primaryColor,
                            gradientColor4: Theme.of(context).primaryColor,
                            containerHeight: MediaQuery.of(context).size.height/20,
                            containerWidth: MediaQuery.of(context).size.width/5,
                            shadowColor1: Colors.white30,
                            shadowColor2: Colors.black,
                            shadow2Offset: 1.0,
                            shadow1Offset: -1.0,
                            spreadRadius1: 1.0,
                            spreadRadius2: 2.0,
                            blurRadius1: 3.0,
                            blurRadius2: 3.0,
                            circleShape: false,
                            containerBorderRadius: BorderRadius.all(Radius.circular(40.0)),),
                          NeoContainer(
                            gradientColor1: Theme.of(context).primaryColor,
                            gradientColor2: Theme.of(context).primaryColor,
                            gradientColor3: Theme.of(context).primaryColor,
                            gradientColor4: Theme.of(context).primaryColor,
                            containerHeight: MediaQuery.of(context).size.height/20,
                            containerWidth: MediaQuery.of(context).size.width/5,
                            shadowColor1: Colors.white30,
                            shadowColor2: Colors.black,
                            shadow2Offset: 1.0,
                            shadow1Offset: -1.0,
                            spreadRadius1: 1.0,
                            spreadRadius2: 2.0,
                            blurRadius1: 3.0,
                            blurRadius2: 3.0,
                            circleShape: false,
                            containerBorderRadius: BorderRadius.all(Radius.circular(40.0)),),
                          NeoContainer(
                            gradientColor1: Theme.of(context).primaryColor,
                            gradientColor2: Theme.of(context).primaryColor,
                            gradientColor3: Theme.of(context).primaryColor,
                            gradientColor4: Theme.of(context).primaryColor,
                            containerHeight: MediaQuery.of(context).size.height/20,
                            containerWidth: MediaQuery.of(context).size.width/5,
                            shadowColor1: Colors.white30,
                            shadowColor2: Colors.black,
                            shadow2Offset: 1.0,
                            shadow1Offset: -1.0,
                            spreadRadius1: 1.0,
                            spreadRadius2: 2.0,
                            blurRadius1: 3.0,
                            blurRadius2: 3.0,
                            circleShape: false,
                            containerBorderRadius: BorderRadius.all(Radius.circular(40.0)),)
                        ],
                      )
                  ),
                ),
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
                            child: Text('Einheiten',
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
                SliverToBoxAdapter(
                    child: Container(
                        height: MediaQuery.of(context).size.height/6,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(10.0),
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
                                  containerChild: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      snapshot.data[index].Name,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),

                              );
                            }
                        )
                    )
                ),
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
                            child: Text('Trainingsweise',
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
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
                      containerChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 50.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: NeoContainer(
                                circleShape: false,
                                containerHeight: MediaQuery.of(context).size.height/20,
                                  containerWidth: MediaQuery.of(context).size.width/1.5,
                                  shadowColor1: Colors.white30,
                                  shadowColor2: Colors.black,
                                  gradientColor1: Theme.of(context).primaryColor,
                                  gradientColor2: Theme.of(context).primaryColor,
                                  gradientColor3: Theme.of(context).primaryColor,
                                  gradientColor4: Theme.of(context).primaryColor,
                                  shadow1Offset: 2.0,
                                  shadow2Offset: -1.0,
                                  spreadRadius2: 0.0,
                                  spreadRadius1: 0.0,
                                  blurRadius2: 0.0,
                                  blurRadius1: 0.0,
                                containerChild: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Colors.red, Colors.transparent],
                                        stops: [0.3, 0.3]
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: NeoContainer(
                              circleShape: false,
                              containerHeight: MediaQuery.of(context).size.height/20,
                              containerWidth: MediaQuery.of(context).size.width/1.5,
                              shadowColor1: Colors.white30,
                              shadowColor2: Colors.black,
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2: Theme.of(context).primaryColor,
                              gradientColor3: Theme.of(context).primaryColor,
                              gradientColor4: Theme.of(context).primaryColor,
                              shadow1Offset: 2.0,
                              shadow2Offset: -1.0,
                              spreadRadius2: 0.0,
                              spreadRadius1: 0.0,
                              blurRadius2: 0.0,
                              blurRadius1: 0.0,
                              containerChild: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [Colors.red, Colors.transparent],
                                      stops: [0.7, 0.7]
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
                            child: Text('Muskelgruppen',
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
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
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }

        }
      ),
    );
  }


  Widget _navigationBar(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    final navbarColor navigationBar = Provider.of<navbarColor>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0),
      child: NeoContainer(
        circleShape: false,
        blurRadius2: 3.0,
        blurRadius1: 3.0,
        shadow1Offset: 2.0,
        gradientColor1: Theme.of(context).primaryColor,
        gradientColor2: Colors.red,
        gradientColor3: Theme.of(context).primaryColor,
        gradientColor4: Theme.of(context).primaryColor,
        shadowColor1: Colors.black,
        shadowColor2: Colors.grey,
        containerWidth: MediaQuery.of(context).size.width/1.2,
        containerHeight: MediaQuery.of(context).size.height/10,
        containerChild: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
                onPressed: () {
                  navigationBar.updatenavIconColor(true, false, false);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MultiProvider(
                            providers: [
                              Provider(create: (context) => StorageHandler(uid: database.uid),),
                              Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                              ChangeNotifierProvider(create: (context) => TabbarColor(context: context)),
                              ChangeNotifierProvider(create: (context) => ButtonbarColor(context: context)),
                              ChangeNotifierProvider(create: (context) => ListViewIndex(context: context)),
                              ChangeNotifierProvider(create: (context) => navbarColor()),
                            ],
                            child: HomeAPage());
                      },
                    ),
                  );
                },
                icon: Consumer<navbarColor>(
                    builder: (context, data, child) {
                      return Icon(
                        Icons.home,
                        color: data.navIconColor1,
                        size: 30.0,
                      );
                    }
                ),
                label: Text('home'.toUpperCase())),
            FlatButton.icon(
                onPressed: () {
                  navigationBar.updatenavIconColor(false, true, false);
                },
                icon: Consumer<navbarColor>(
                    builder: (context, data, child) {
                      return Icon(
                        Icons.analytics,
                        color: data.navIconColor2,
                        size: 30.0,
                      );
                    }
                ),
                label: Text('')),
            FlatButton.icon(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Consumer<navbarColor>(
                  builder: (context, data, child) {
                    return Icon(
                      Icons.folder_shared,
                      color: data.navIconColor3,
                      size: 30.0,
                    );
                  },
                ),
                label: Text(''),
                onPressed: () {
                  navigationBar.updatenavIconColor(false, false, true);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MultiProvider(
                            providers: [
                              Provider(create: (context) =>
                                  DatabaseHandler(uid: database.uid),),
                              ChangeNotifierProvider(create: (context) =>
                                  TextRoutine()),
                            ],
                            child: MyWorkoutsAPage());
                      },
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }


}


