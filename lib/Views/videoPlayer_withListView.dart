import 'dart:async';
import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/listViewIndex.dart';
import 'package:video_app/Notifyers/navigationBar_notifyer.dart';
import 'package:video_app/Notifyers/sortBar_notifyer.dart';
import 'package:video_app/Notifyers/tabbar_color.dart';
import 'package:video_app/Notifyers/timerEnd_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Services/storage_handler.dart';
import 'package:video_app/Views/center_a.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class VideoPlayerList extends StatefulWidget {

  final List urlList;
  final List classifycationList;
  final List muscleGroupsList;
  final List thumbnialsList;
  final List workoutNameList;
  final String workoutName;

  const VideoPlayerList({Key key,@required this.urlList, @required this.workoutName, @required this.thumbnialsList, @required this.classifycationList, @required this.muscleGroupsList, @required this.workoutNameList}) : super(key: key);

  @override
  _VideoPlayerListState createState() => _VideoPlayerListState();
}

class _VideoPlayerListState extends State<VideoPlayerList> {


  Future<Einheit> _createfinishWorkout() async {
    try {
      final database = Provider.of<DatabaseHandler>(context, listen: false);
      await database.createFinishWorkout(Einheit(
            Name: widget.workoutName,
            Dauer: _videoPlayerController.value.duration.toString(),
            VideoUrl: widget.urlList,
            Klassifizierung: widget.classifycationList,
            Muskelgruppen: widget.muscleGroupsList,
            Thumbnail: widget.thumbnialsList,
            Uebungsnamen: widget.workoutNameList,
            Datum: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
      ));
    } catch (e) {
      print(e);
    }
  }


  PageController controller = PageController();

  TargetPlatform platform;
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  //ChewieController chewieController;
  int selectedIndex;
  List<Color> listItemColor = new List<Color>();
  bool kill_playVideo;
  bool _isPlaying = false;

  Einheit einheit;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    kill_playVideo = false;
    print('url ${widget.urlList}');
    _videoPlayerController = VideoPlayerController.network(widget.urlList[0]);
    _videoPlayerController.setLooping(false);
    _videoPlayerController.play();
    _videoPlayerController.addListener(() {
      final bool isPlaying = _videoPlayerController.value.isPlaying;
      if (isPlaying != _isPlaying) {
        setState(() {
          log('$isPlaying');
          _isPlaying = isPlaying;
        });
      }
      if(_videoPlayerController.value.duration == _videoPlayerController.value.position)  {
        log('done.........!');
        setState(() {

        });
      }
    });
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    //timer();
    //selectedIndex = 0;

    //videoPlayerController.addListener(_videoListener);
    //chewieController = ChewieController(
      //videoPlayerController: videoPlayerController,
      //aspectRatio: 3 / 2,
      //autoPlay: true,
      //looping: true,
      // Try playing around with some of these other options:
      // showControls: true,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
   // );
  }


  @override
  void dispose() {
    //chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }


  void timer() async {
    final TimerNotifyer timerNotifyer = Provider.of<TimerNotifyer>(context);
    const oneSec = const Duration(seconds: 10);
    //selectedIndex = timerNotifyer.index;

      //imerNotifyer.update(i);
    Future.delayed(oneSec, () {
      final new_selectedIndex = 2;
      debugPrint('$new_selectedIndex');
      final new_videoPlayerController = VideoPlayerController.network(widget.urlList[new_selectedIndex]);
      final old_videoPlayerController = _videoPlayerController;
      if (old_videoPlayerController != null) {
        old_videoPlayerController.pause();
      }
      _videoPlayerController = new_videoPlayerController;
      //controller.jumpToPage(new_selectedIndex);
      setState(() {
        debugPrint('----- controller changed');
      });

      new_videoPlayerController
        ..initialize().then((_) {
          debugPrint("---- controller initialized");
          old_videoPlayerController?.dispose();
          new_videoPlayerController.setLooping(true);
          new_videoPlayerController.play();
          setState(() {});
        });

    });


  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _routePageBuilder(context);
                } else {
                  return Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(
                        minHeight: 30.0,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  );
                }

              }
            )
        ),
      );
    }

    Widget _routePageBuilder(BuildContext context) {
      final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
      if(_videoPlayerController.value.duration == _videoPlayerController.value.position)  {
        return Stack(
          children: [
            PageView.builder(
              itemBuilder: (context, position) {
                return AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController));
                },
                  itemCount: widget.urlList.length,
                  controller: controller,
                ),
            Container(
              color: Colors.black.withOpacity(0.8),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: Container(
                height: MediaQuery.of(context).size.height/4,
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text('Geschafft',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'FiraSansExtraCondensed',
                    fontSize: 30.0
                  ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              right: 50,
              bottom: 100,
              top: 400,
              child: GestureDetector(
                onTap: () {
                  _createfinishWorkout();
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
                            child:  CenterAPage());
                      },
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height/8,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    border: Border.all(
                      color: Colors.redAccent
                    ),
                  ),
                  child: Center(
                    child: Text('Workout Beenden',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'FiraSansExtraCondensed',
                        fontSize: 30.0
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]
        );
      } else {
        return PageView.builder(
          itemBuilder: (context, position) {
            return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController));
          },
          itemCount: widget.urlList.length,
          controller: controller,
        );
      }

    }

    /*
    Widget _player() {
    timer().whenComplete(() {
      chewieController.play();
      return Container(
          color: Colors.red,
          child: Chewie(controller: chewieController));
    });


    }

     */

  }

