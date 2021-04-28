import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/CustomWidgets/persistant_sliver_header.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/timerEnd_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/videoPlayer2_a.dart';
import 'package:video_app/Views/videoPlayerChewie.dart';
import 'package:video_app/Views/videoPlayer_withListView.dart';
import 'package:video_app/videoplayerservice.dart';

class Workout3APage extends StatefulWidget {

  final routineName;

  const Workout3APage({Key key,@required this.routineName}) : super(key: key);

  @override
  _Workout3APageState createState() => _Workout3APageState();
}


class _Workout3APageState extends State<Workout3APage> {


  Workout routine;

  String workout;

  String videoPath;

  Future<Workout> getWorkoutList(BuildContext context) async {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    try {
      final Workout Input = await database.getRoutineCustomMap(widget.routineName);
      routine = Input;
    } catch(e) {
      print(e);
    }
    return routine;
  }

  bool firstVisit;

  @override
  void initState() {
    firstVisit = false;
    workout = '';
    videoPath = '';
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    if (firstVisit == false) {
      getWorkoutList(context).then((value){
        setState(() {
          workout = value.workout;
          videoPath = value.videoPath;
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
                            child: Text(workout,
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: 1
              )),
          SliverAppBar(
            automaticallyImplyLeading: false,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MultiProvider(
                          providers: [
                            ChangeNotifierProvider(create: (context) => TimerNotifyer()),
                          ], child: SamplePlayer(videourl: videoPath),
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
            ],
          )
        ],
      ),
    );
  }


}
