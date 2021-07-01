import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/listViewIndex.dart';
import 'package:video_app/Notifyers/navigationBar_notifyer.dart';
import 'package:video_app/Notifyers/sortBar_notifyer.dart';
import 'package:video_app/Notifyers/tabbar_color.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Services/storage_handler.dart';
import 'package:video_app/Views/center_a.dart';
import 'package:intl/intl.dart';

class FinishAnimation extends StatefulWidget {

  final routine;
  final List artboard;
  final duration;
  final level;
  final pause;
  final sets;
  final training;
  final workout;
  final muscle;
  final thumbnail;
  final date;

  const FinishAnimation({Key key, this.routine, this.artboard, this.duration, this.level, this.pause, this.sets, this.training, this.workout, this.muscle, this.thumbnail, this.date}) : super(key: key);


  @override
  _FinishAnimationState createState() => _FinishAnimationState();
}



class _FinishAnimationState extends State<FinishAnimation> {

  FinishRoutineAnimation _finishRoutine;

  @override
  void initState() {
    super.initState();
    String currentDate() => DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    _finishRoutine = FinishRoutineAnimation(
        workout: widget.workout,
        thumbnail: widget.thumbnail,
        routine: widget.routine,
        artboard: widget.artboard,
        duration: widget.artboard.length*(widget.pause+widget.training)*widget.sets,
        muscle: widget.muscle,
        level: widget.level,
        date: currentDate(),
        training: widget.training,
        pause: widget.pause,
        sets: widget.sets);
  }


  @override
  Widget build(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            height: 100.0,
            width: 200.0,
            color: Colors.blue,
            child: TextButton(
              onPressed: () {
                // Funktion für Speichern des Workouts in fder History
                database.createFinishWorkout(_finishRoutine);
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
            ),
          ),
        ),
      ),
    );
  }
}
