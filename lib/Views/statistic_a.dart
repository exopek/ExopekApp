import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/CustomWidgets/persistant_sliver_header.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';


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

  List finishWorkoutList;

  var kraft;
  var ausdauer;
  var brust;
  var beine;
  var bauch;
  var schultern;
  var ruecken;
  var counter_uebungen;

  double prozent_kraft;
  double prozent_ausdauer;
  double prozent_brust;
  double prozent_beine;
  double prozent_bauch;
  double prozent_schultern;
  double prozent_ruecken;

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


  // Kalender

  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _weekBegin;
  String _weekEnd;
  DateTime _datetime_weekBegin;
  DateTime _datetime_weekEnd;
  int _datetime_month;
  int _datetime_year;
  bool _week;
  bool _month;
  bool _year;
  String _currentMonth = DateFormat.yM().format(DateTime.now());
  String _currentWeekday = DateFormat.EEEE().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  Color _woche_color;
  Color _monat_color;
  Color _jahr_color;

  CalendarCarousel _calendarCarouselNoHeader;

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2020, 2, 10): [
        new Event(
          date: new DateTime(2020, 2, 14),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2020, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2020, 2, 15),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  List calculate_Week_Start_and_End() {
    if (_currentDate.weekday == 7) {
      _weekBegin = DateFormat('yyyy-MM-dd').format(DateTime(
          _currentDate.year, _currentDate.month, _currentDate.day - 6));
      _weekEnd = DateFormat('yyyy-MM-dd').format(
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day));
    }
    else if (_currentDate.weekday == 1) {
      _weekBegin = DateFormat('yyyy-MM-dd').format(DateTime(
          _currentDate.year, _currentDate.month, _currentDate.day));
      _weekEnd = DateFormat('yyyy-MM-dd').format(
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day + 6));
    }
    else if (_currentDate.weekday == 2) {
      _weekBegin = DateFormat('yyyy-MM-dd').format(DateTime(
          _currentDate.year, _currentDate.month, _currentDate.day - 1));
      _weekEnd = DateFormat('yyyy-MM-dd').format(
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day + 5));
    }
    else if (_currentDate.weekday == 3) {
      _weekBegin = DateFormat('yyyy-MM-dd').format(DateTime(
          _currentDate.year, _currentDate.month, _currentDate.day - 2));
      _weekEnd = DateFormat('yyyy-MM-dd').format(
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day + 4));
    }
    else if (_currentDate.weekday == 4) {
      _weekBegin = DateFormat('yyyy-MM-dd').format(DateTime(
          _currentDate.year, _currentDate.month, _currentDate.day - 3));
      _weekEnd = DateFormat('yyyy-MM-dd').format(
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day + 3));
    }
    else if (_currentDate.weekday == 5) {
      _weekBegin = DateFormat('yyyy-MM-dd').format(DateTime(
          _currentDate.year, _currentDate.month, _currentDate.day - 4));
      _weekEnd = DateFormat('yyyy-MM-dd').format(
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day + 2));
    }
    else if (_currentDate.weekday == 6) {
      _weekBegin = DateFormat('yyyy-MM-dd').format(DateTime(
          _currentDate.year, _currentDate.month, _currentDate.day - 5));
      _weekEnd = DateFormat('yyyy-MM-dd').format(
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day + 1));
    }



    return [_weekBegin, _weekEnd];
  }


  void sort_Week(snapshot) {
    for (int i = 0; i < snapshot.data.length; i++) {
      final databaseDay = DateTime.parse(snapshot.data[i].Datum);
      if (databaseDay.year == _datetime_weekBegin.year && databaseDay.month == _datetime_weekBegin.month && databaseDay.day >= _datetime_weekBegin.day && databaseDay.day <= _datetime_weekEnd.day) {
        finishWorkoutList.add(snapshot.data[i]);
      } else {
        log('message');
      }
    }
  }

  void sort_Month(snapshot) {
    for (int i = 0; i < snapshot.data.length; i++) {
      final databaseDay = DateTime.parse(snapshot.data[i].Datum);
      if (databaseDay.year == _datetime_year && databaseDay.month == _datetime_month) {
        finishWorkoutList.add(snapshot.data[i]);
      } else {
        log('message');
      }
    }
  }

  void sort_Year(snapshot) {
    for (int i = 0; i < snapshot.data.length; i++) {
      final databaseDay = DateTime.parse(snapshot.data[i].Datum);
      if (databaseDay.year == _datetime_year) {
        finishWorkoutList.add(snapshot.data[i]);
      } else {
        log('message');
      }
    }
  }

  void count_ausdauer_kraft() {
    for (int i = 0; i < finishWorkoutList.length; i++) {
      if (finishWorkoutList[i].Klassifizierung[0] == 'Kraft') {
        kraft = kraft + 1;
      } else if (finishWorkoutList[i].Klassifizierung[0] == 'Ausdauer') {
        ausdauer = ausdauer + 1;
      } else {
        ausdauer = 0;
        kraft = 0;
        log('message: ${finishWorkoutList.length}');
      }
    }
  }

  void count_muskelgruppen() {
    for (int i = 0; i < finishWorkoutList.length; i++) {
      for (var value in finishWorkoutList[i].Muskelgruppen) {
        if (value == 'Brust') {
          brust = brust + 1;
          counter_uebungen = counter_uebungen + 1;
        } else if (value == 'Beine') {
          beine = beine + 1;
          counter_uebungen = counter_uebungen + 1;
        } else if (value == 'Schultern') {
          schultern = schultern + 1;
          counter_uebungen = counter_uebungen + 1;
        } else if (value == 'Rücken') {
          ruecken = ruecken + 1;
          counter_uebungen = counter_uebungen + 1;
        } else if (value == 'Bauch') {
          bauch = bauch + 1;
          counter_uebungen = counter_uebungen + 1;
        }
      }
    }
  }


  @override
  void initState() {
    finishWorkoutList = [];
    firstVisit = false;
    workout = [];
    videoPath = [];
    kraft = 0;
    ausdauer = 0;
    brust = 0;
    beine = 0;
    bauch = 0;
    schultern = 0;
    ruecken = 0;
    counter_uebungen = 0;
    prozent_kraft = 0;
    prozent_ausdauer = 0;
    prozent_beine = 0;
    prozent_bauch = 0;
    prozent_brust = 0;
    prozent_schultern = 0;
    prozent_ruecken = 0;
    _weekBegin = calculate_Week_Start_and_End()[0];
    _weekEnd = calculate_Week_Start_and_End()[1];
    _datetime_weekBegin = DateTime.parse(_weekBegin);
    _datetime_weekEnd = DateTime.parse(_weekEnd);
    _datetime_month = _currentDate.month;
    _datetime_year = _currentDate.year;
    _week = true;
    _month = false;
    _year = false;
    _woche_color = Colors.redAccent;
    _monat_color = Colors.white;
    _jahr_color = Colors.white;
    /*
    _markedDateMap.add(
        new DateTime(2021, 5, 25),
        new Event(
          date: new DateTime(2021, 5, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime(2020, 2, 10),
        new Event(
          date: new DateTime(2020, 2, 10),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(new DateTime(2019, 2, 11), [
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
    */
    super.initState();
  }


  @override
  Widget build(BuildContext context) {



    /*
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      pageScrollPhysics: ScrollPhysics(

      ),
      //pageScrollPhysics: PageScrollPhysics().createBallisticSimulation(position, velocity),
      pageSnapping: true,
      todayBorderColor: Colors.red,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        //events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: BouncingScrollPhysics(),
      markedDateCustomShapeBorder:
      CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),

      todayButtonColor: Colors.white,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      /*
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },

       */
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );
    */

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
            finishWorkoutList.clear();
            kraft = 0;
            ausdauer = 0;
            brust = 0;
            beine = 0;
            bauch = 0;
            schultern = 0;
            ruecken = 0;
            counter_uebungen = 0;
            // Befüllt die Liste für den angegebenen Zeitraum einer Woche.
            if (_week == true) {
              sort_Week(snapshot);
            } else if (_month == true) {
              sort_Month(snapshot);
            } else if (_year == true) {
              sort_Year(snapshot);
            }

            // Ermittelt die Häufigkeit der Tag's Kraft und Ausdauer in den geladenen Modelen Einheit.
            count_ausdauer_kraft();
            count_muskelgruppen();

            if (finishWorkoutList.length == 0) {
              prozent_kraft = 0;
              prozent_ausdauer = 0;
              prozent_beine = 0;
              prozent_bauch = 0;
              prozent_brust = 0;
              prozent_schultern = 0;
              prozent_ruecken = 0;
            } else {
              prozent_kraft = (kraft/finishWorkoutList.length)*100;
              prozent_ausdauer = (ausdauer/finishWorkoutList.length)*100;
              prozent_beine = (beine/counter_uebungen)*100;
              prozent_bauch = (bauch/counter_uebungen)*100;
              prozent_brust = (brust/counter_uebungen)*100;
              prozent_schultern = (schultern/counter_uebungen)*100;
              prozent_ruecken = (ruecken/counter_uebungen)*100;
            }

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
                /*
                SliverToBoxAdapter(
                  child: Container(   // Hier war vorher SingleChildScrollView
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                //custom icon

                Container(
                margin: EdgeInsets.only(
                top: 30.0,
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                ),
                child: new Row(
                children: <Widget>[
                Expanded(
                child: Text(
                _currentMonth,
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                ),
                )),
                FlatButton(
                child: Text('ZURÜCK'),
                onPressed: () {
                setState(() {
                _targetDateTime = DateTime(
                _targetDateTime.year, _targetDateTime.month - 1);
                _currentMonth =
                DateFormat.yMMM().format(_targetDateTime);
                });
                },
                ),
                FlatButton(
                child: Text('WEITER'),
                onPressed: () {
                setState(() {
                _targetDateTime = DateTime(
                _targetDateTime.year, _targetDateTime.month + 1);
                _currentMonth =
                DateFormat.yMMM().format(_targetDateTime);
                });
                },
                )
                ],
                ),
                ),
                Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
                ), //
                ],
                ),
                ),
                ),
                */

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Container(
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NeoContainer(
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2: Theme.of(context).primaryColor,
                              gradientColor3: Theme.of(context).primaryColor,
                              gradientColor4: Theme.of(context).primaryColor,
                              containerHeight: MediaQuery.of(context).size.height/20,
                              containerWidth: MediaQuery.of(context).size.width/4,
                              shadowColor1: Colors.black,
                              shadowColor2: Colors.white30,
                              //shadow2Offset: 1.0,
                              //shadow1Offset: -1.0,
                              //spreadRadius1: 1.0,
                              spreadRadius2: 0.0,
                              //blurRadius1: 3.0,
                              //blurRadius2: 3.0,
                              circleShape: false,
                              containerBorderRadius: BorderRadius.all(Radius.circular(40.0)),
                              containerChild: InkWell(
                                onTap: () {
                                  setState(() {
                                    _week = true;
                                    _month = false;
                                    _year = false;
                                    _woche_color = Colors.redAccent;
                                    _monat_color = Colors.white;
                                    _jahr_color = Colors.white;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    'Woche',
                                    style: TextStyle(
                                      color: _woche_color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            NeoContainer(
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2: Theme.of(context).primaryColor,
                              gradientColor3: Theme.of(context).primaryColor,
                              gradientColor4: Theme.of(context).primaryColor,
                              containerHeight: MediaQuery.of(context).size.height/20,
                              containerWidth: MediaQuery.of(context).size.width/4,
                              shadowColor1: Colors.black,
                              shadowColor2: Colors.white30,
                              //shadow2Offset: 1.0,
                              //shadow1Offset: -1.0,
                              //spreadRadius1: 1.0,
                              spreadRadius2: 0.0,
                              //blurRadius1: 3.0,
                              //blurRadius2: 3.0,
                              circleShape: false,
                              containerBorderRadius: BorderRadius.all(Radius.circular(40.0)),
                              containerChild: InkWell(
                                onTap: () {
                                  setState(() {
                                    _week = false;
                                    _month = true;
                                    _year = false;
                                    _woche_color = Colors.white;
                                    _monat_color = Colors.redAccent;
                                    _jahr_color = Colors.white;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    'Monat',
                                    style: TextStyle(
                                        color: _monat_color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            NeoContainer(
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2: Theme.of(context).primaryColor,
                              gradientColor3: Theme.of(context).primaryColor,
                              gradientColor4: Theme.of(context).primaryColor,
                              containerHeight: MediaQuery.of(context).size.height/20,
                              containerWidth: MediaQuery.of(context).size.width/4,
                              shadowColor1: Colors.black,
                              shadowColor2: Colors.white30,
                              //shadow2Offset: 1.0,
                              //shadow1Offset: -1.0,
                              //spreadRadius1: 1.0,
                              spreadRadius2: 0.0,
                              //blurRadius1: 3.0,
                              //blurRadius2: 3.0,
                              circleShape: false,
                              containerBorderRadius: BorderRadius.all(Radius.circular(40.0)),
                              containerChild: InkWell(
                                onTap: () {
                                  setState(() {
                                    _week = false;
                                    _month = false;
                                    _year = true;
                                    _woche_color = Colors.white;
                                    _monat_color = Colors.white;
                                    _jahr_color = Colors.redAccent;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    'Jahr',
                                    style: TextStyle(
                                        color: _jahr_color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Container(
                          color: Theme.of(context).primaryColor,
                          height: MediaQuery.of(context).size.height*0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07),
                                child: NeoContainer(
                                    containerHeight: MediaQuery.of(context).size.height*0.07,
                                    containerWidth: MediaQuery.of(context).size.height*0.07,
                                    circleShape: true,
                                    gradientColor1: Theme.of(context).primaryColor,
                                    gradientColor2: Theme.of(context).primaryColor,
                                    gradientColor3: Theme.of(context).primaryColor,
                                    gradientColor4: Theme.of(context).primaryColor,
                                    shadowColor1: Colors.black,
                                    spreadRadius2: 0.0,
                                    shadowColor2: Colors.white30,
                                    containerChild: InkWell(
                                      onTap: () {
                                        if (_week == true) {
                                          final _oldDateTime_weekBegin = _datetime_weekBegin;
                                          final _oldDateTime_weekEnd = _datetime_weekEnd;
                                          setState(() {
                                            _datetime_weekEnd = DateTime(_oldDateTime_weekEnd.year, _oldDateTime_weekEnd.month, _oldDateTime_weekEnd.day - 7);
                                            _datetime_weekBegin = DateTime(_oldDateTime_weekBegin.year, _oldDateTime_weekBegin.month, _oldDateTime_weekBegin.day - 7);
                                            _weekBegin = DateFormat('yyyy-MM-dd').format(_datetime_weekBegin);
                                            _weekEnd = DateFormat('yyyy-MM-dd').format(_datetime_weekEnd);
                                            finishWorkoutList.clear();
                                          });
                                        } else if (_month == true) {
                                          final _newDateTime_month = DateTime(_currentDate.year, _datetime_month - 1, _currentDate.day);
                                          setState(() {
                                            _datetime_month = _newDateTime_month.month;
                                            finishWorkoutList.clear();
                                          });
                                        } else if (_year == true) {
                                          final _newDateTime_year = DateTime(_datetime_year - 1, _currentDate.month, _currentDate.day);
                                          setState(() {
                                            _datetime_year = _newDateTime_year.year;
                                            finishWorkoutList.clear();
                                          });
                                        }

                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios_sharp
                                      ),
                                    ),
                                ),
                              ),
                              _week_month_year_content(context),
                              Padding(
                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.07),
                                child: NeoContainer(
                                    containerHeight: MediaQuery.of(context).size.height*0.07,
                                    containerWidth: MediaQuery.of(context).size.height*0.07,
                                    circleShape: true,
                                    gradientColor1: Theme.of(context).primaryColor,
                                    gradientColor2: Theme.of(context).primaryColor,
                                    gradientColor3: Theme.of(context).primaryColor,
                                    gradientColor4: Theme.of(context).primaryColor,
                                    spreadRadius2: 0.0,
                                    shadowColor1: Colors.black,
                                    shadowColor2: Colors.white30,
                                    containerChild: InkWell(
                                      onTap: () {
                                        if (_week == true) {
                                          final _oldDateTime_weekBegin = _datetime_weekBegin;
                                          final _oldDateTime_weekEnd = _datetime_weekEnd;
                                          setState(() {
                                            _datetime_weekEnd = DateTime(_oldDateTime_weekEnd.year, _oldDateTime_weekEnd.month, _oldDateTime_weekEnd.day + 7);
                                            _datetime_weekBegin = DateTime(_oldDateTime_weekBegin.year, _oldDateTime_weekBegin.month, _oldDateTime_weekBegin.day + 7);
                                            _weekBegin = DateFormat('yyyy-MM-dd').format(_datetime_weekBegin);
                                            _weekEnd = DateFormat('yyyy-MM-dd').format(_datetime_weekEnd);
                                            finishWorkoutList.clear();
                                          });
                                        } else if (_month == true) {
                                          final _newDateTime_month = DateTime(_currentDate.year, _datetime_month + 1, _currentDate.day);
                                          setState(() {
                                            _datetime_month = _newDateTime_month.month;
                                            finishWorkoutList.clear();
                                          });
                                        } else if (_year == true) {
                                          final _newDateTime_year = DateTime(_datetime_year + 1, _currentDate.month, _currentDate.day);
                                          setState(() {
                                            _datetime_year = _newDateTime_year.year;
                                            finishWorkoutList.clear();
                                          });
                                        }

                                      },
                                      child: Icon(
                                          Icons.arrow_forward_ios_sharp
                                      ),
                                    ),
                                ),
                              ),
                            ],
                          )
                      ),
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
                          color: Colors.white,
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
                            itemCount: finishWorkoutList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: NeoContainer(
                                  containerHeight: MediaQuery.of(context).size.height/3,
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
                                  containerChild: Container(
                                    child: Center(
                                      child: Text(
                                        finishWorkoutList[index].Name,
                                        style: TextStyle(
                                          fontFamily: 'FiraSansExtraCondensed',
                                          color: Colors.white,
                                          fontSize: 20.0
                                        ),
                                      ),
                                    ),
                                ),
                                )
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
                          color: Colors.white,
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
                    padding: EdgeInsets.all(10.0),
                    child: NeoContainer(
                      containerHeight: MediaQuery.of(context).size.height/5,
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
                      containerChild: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 40.0,
                                width: 200.0,
                                color: Theme.of(context).primaryColor,
                                child: Center(
                                  child: Text('Dein Übungsanteil, welcher sich auf den Aufbau von Kraft konzentriert',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'FiraSansExtraCondensed',
                                        fontSize: 20.0
                                    ),),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0, top: 5.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text('${prozent_kraft.round().toString()}%',
                                  style: TextStyle(
                                    color: Color.fromRGBO(231, 40, 44, 1),
                                    fontFamily: 'FiraSansExtraCondensed',
                                    fontSize: 30.0
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: NeoContainer(
                                circleShape: false,
                                containerHeight: MediaQuery.of(context).size.height*0.02,
                                  containerWidth: MediaQuery.of(context).size.width/1.2,
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
                                        colors: [Color.fromRGBO(231, 40, 44, 1), Colors.transparent],
                                        stops: [prozent_kraft/100, prozent_kraft/100]
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: NeoContainer(
                      containerHeight: MediaQuery.of(context).size.height/5,
                      containerWidth: MediaQuery.of(context).size.width/2,
                      containerBorderRadius: BorderRadius.all(Radius.circular(15.0)),
                      circleShape: false,
                      spreadRadius2: 0.0,
                      shadowColor2: Colors.white60,
                      shadowColor1: Colors.black,
                      gradientColor1: Theme.of(context).primaryColor,
                      gradientColor2: Theme.of(context).primaryColor,
                      gradientColor3: Theme.of(context).primaryColor,
                      gradientColor4: Theme.of(context).primaryColor,
                      containerChild: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 40.0,
                                width: 220.0,
                                color: Theme.of(context).primaryColor,
                                child: Center(
                                  child: Text('Dein Übungsanteil, welcher sich auf den Aufbau von Ausdauer konzentriert',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'FiraSansExtraCondensed',
                                        fontSize: 20.0
                                    ),),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0, top: 5.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text('${prozent_ausdauer.round().toString()}%',
                                  style: TextStyle(
                                      color: Color.fromRGBO(231, 40, 44, 1),
                                      fontFamily: 'FiraSansExtraCondensed',
                                      fontSize: 30.0
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: NeoContainer(
                                circleShape: false,
                                containerHeight: MediaQuery.of(context).size.height*0.02,
                                containerWidth: MediaQuery.of(context).size.width/1.2,
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
                                        colors: [Color.fromRGBO(231, 40, 44, 1), Colors.transparent],
                                        stops: [prozent_ausdauer/100, prozent_ausdauer/100]
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                          color: Colors.white,
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
                    padding: EdgeInsets.all(10.0),
                    child: NeoContainer(
                      containerHeight: MediaQuery.of(context).size.height/1.6,
                      containerWidth: MediaQuery.of(context).size.width/2,
                      containerBorderRadius: BorderRadius.all(Radius.circular(15.0)),
                      circleShape: false,
                      spreadRadius2: 0.0,
                      shadowColor2: Colors.white60,
                      shadowColor1: Colors.black,
                      gradientColor1: Theme.of(context).primaryColor,
                      gradientColor2: Theme.of(context).primaryColor,
                      gradientColor3: Theme.of(context).primaryColor,
                      gradientColor4: Theme.of(context).primaryColor,
                      containerChild: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height/35,),
                          _muscle_group_content(context, 'Brustübungen', prozent_brust),
                          _muscle_group_content(context, 'Beinübungen', prozent_beine),
                          _muscle_group_content(context, 'Schulterübungen', prozent_schultern),
                          _muscle_group_content(context, 'Rückenübungen', prozent_ruecken),
                          _muscle_group_content(context, 'Bauchübungen', prozent_bauch),
                        ],
                      ),
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

  Widget _muscle_group_content(BuildContext context, String bezeichnung, double prozent_uebung) {
    return Container(
      height: MediaQuery.of(context).size.height/9,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/18, top: MediaQuery.of(context).size.height/400, bottom: MediaQuery.of(context).size.height/100),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 40.0,
                width: 100.0,
                color: Theme.of(context).primaryColor,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(bezeichnung,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'FiraSansExtraCondensed',
                        fontSize: 20.0
                    ),),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/18, top: MediaQuery.of(context).size.height/100),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                child: Text('${prozent_uebung.round().toString()}%',
                  style: TextStyle(
                      color: Color.fromRGBO(231, 40, 44, 1),
                      fontFamily: 'FiraSansExtraCondensed',
                      fontSize: 30.0
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/15),
            child: Align(
              alignment: Alignment.topCenter,
              child: NeoContainer(
                circleShape: false,
                containerHeight: MediaQuery.of(context).size.height*0.02,
                containerWidth: MediaQuery.of(context).size.width/1.2,
                shadowColor1: Colors.white30,
                shadowColor2: Colors.black,
                gradientColor1: Theme.of(context).primaryColor,
                gradientColor2: Theme.of(context).primaryColor,
                gradientColor3: Theme.of(context).primaryColor,
                gradientColor4: Theme.of(context).primaryColor,
                shadow1Offset: 1.0,
                shadow2Offset: -1.0,
                spreadRadius2: 0.0,
                spreadRadius1: 0.0,
                blurRadius2: 0.0,
                blurRadius1: 0.0,
                containerChild: AnimatedContainer(
                  duration: Duration(seconds: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color.fromRGBO(231, 40, 44, 1), Colors.transparent],
                        stops: [prozent_uebung/100, prozent_uebung/100]
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )

    );
  }


  Widget _week_month_year_content(BuildContext context) {
    if (_week == true) {
      return Text('${_weekBegin}   -   ${_weekEnd}',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'FiraSansExtraCondensed',
              fontSize: 20.0
          ));
    } else if (_month == true) {
      String _dateString = '';
        if (_datetime_month == 1) {
          _dateString = 'Januar';
        }
        else if (_datetime_month == 2) {
          _dateString = 'Februar';
        }
        else if (_datetime_month == 3) {
          _dateString = 'März';
        }
        else if (_datetime_month == 4) {
          _dateString = 'April';
        }
        else if (_datetime_month == 5) {
          _dateString = 'Mai';
        }
        else if (_datetime_month == 6) {
          _dateString = 'Juni';
        }
        else if (_datetime_month == 7) {
          _dateString = 'Juli';
        }
        else if (_datetime_month == 8) {
          _dateString = 'August';
        }
        else if (_datetime_month == 9) {
          _dateString = 'September';
        }
        else if (_datetime_month == 10) {
          _dateString = 'Oktober';
        }
        else if (_datetime_month == 11) {
          _dateString = 'November';
        }
        else if (_datetime_month == 12) {
          _dateString = 'Dezember';
        }
      return Text('${_dateString}',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'FiraSansExtraCondensed',
              fontSize: 20.0
          ));
    } else if (_year == true) {
      return Text('${_datetime_year.toString()}',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'FiraSansExtraCondensed',
              fontSize: 20.0
          ));
    }
  }



}


