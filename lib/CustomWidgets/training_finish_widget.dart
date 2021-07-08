import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
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

  List<Color> _iconColors;
  List<IconData> _statsIcon;
  List<String> _statsTitle;
  List<String> _statsValue;
  String _duration;


  @override
  void initState() {
    super.initState();
    _duration = '${Duration(seconds: widget.artboard.length*(widget.pause+widget.training)*widget.sets)}';
    _iconColors = [Colors.deepPurple, Colors.pink, Colors.teal, Colors.cyanAccent, Colors.indigoAccent];
    _statsIcon = [Icons.timer, Icons.whatshot, Icons.circle, Icons.circle, Icons.circle];
    _statsTitle = ['Dauer deines Trainings', 'Kalorien', '', '', ''];
    _statsValue = [_duration.substring(2,7), '', '', '', ''];
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Traingswerte',
                style: TextStyle(
                  fontFamily: 'FiraSansExtraCondensed'
                ),
        ),
        centerTitle: true,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.63,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return _trainingStats(context, Icon(_statsIcon[index], color: _iconColors[index],), Text(_statsTitle[index], style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),),
                          Text(_statsValue[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0))
                      );
                    }),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.2,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: NeoContainer(
                    containerHeight: MediaQuery.of(context).size.height/10,
                    containerWidth: MediaQuery.of(context).size.width/2,
                    containerBorderRadius: BorderRadius.all(Radius.circular(15.0)),
                    circleShape: false,
                    spreadRadius2: 0.0,
                    shadowColor2: Colors.white30,
                    shadowColor1: Colors.black,
                    gradientColor1: Theme.of(context).primaryColor,
                    gradientColor2: Theme.of(context).primaryColor,
                    gradientColor3: Theme.of(context).primaryColor,
                    gradientColor4: Theme.of(context).primaryColor,
                    containerChild: TextButton(
                      style: ButtonStyle(

                      ),
                      child: Text('Speichern', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
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
            ],
          ),
        ),
    );
  }

  Widget _trainingStats(BuildContext context, Widget icon, Widget titleText, Widget statsText) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: NeoContainer(
        containerHeight: MediaQuery.of(context).size.height/8,
        containerWidth: MediaQuery.of(context).size.width/2,
        containerBorderRadius: BorderRadius.all(Radius.circular(15.0)),
        circleShape: false,
        spreadRadius2: 0.0,
        shadowColor2: Colors.white30,
        shadowColor1: Colors.black,
        gradientColor1: Theme.of(context).primaryColor,
        gradientColor2: Theme.of(context).primaryColor,
        gradientColor3: Theme.of(context).primaryColor,
        gradientColor4: Theme.of(context).primaryColor,
        containerChild: Center(
          child: ListTile(
            leading: icon,
            title: titleText,
            trailing: statsText,
          ),
        ),
      ),
    );
  }
}
