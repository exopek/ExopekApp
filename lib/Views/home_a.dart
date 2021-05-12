import 'dart:math';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/Helpers/blank.dart';
import 'package:video_app/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Notifyers/categoryTabBarIndex.dart';
import 'package:video_app/Notifyers/infoTextRoutine_notifyer.dart';
import 'package:video_app/Notifyers/navigationBar_notifyer.dart';
import 'package:video_app/Notifyers/tabbar_color.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/category_a.dart';
import 'package:video_app/Views/functional_a.dart';
import 'package:video_app/Views/mobility_a.dart';
import 'package:video_app/Views/myWorkouts_a.dart';
import 'package:video_app/Views/settings.dart';
import 'package:video_app/Views/statistic_a.dart';
import 'package:video_app/Views/workout_a.dart';

import 'category_myworkouts_a.dart';

class HomeAPage extends StatefulWidget {
  @override
  _HomeAPageState createState() => _HomeAPageState();
}

class _HomeAPageState extends State<HomeAPage> {


  PageController _pageViewController;

  double viewportFraction = 0.8;

  double pageOffset = 0.0;


  @override
  void initState() {
    _pageViewController = PageController(initialPage: 0, viewportFraction: viewportFraction)
      ..addListener(() {
        setState(() {
          pageOffset = _pageViewController.page;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      //bottomNavigationBar: _navigationBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 80, left: MediaQuery.of(context).size.width/8, right: MediaQuery.of(context).size.width/8),
              child: _header(context),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return MultiProvider(
                              providers: [
                                Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                                ChangeNotifierProvider(create: (context) => CTabBarIndex(context: context)),
                              ],
                              child: SettingsPage());
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    child: Center(
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8, top: MediaQuery.of(context).size.height/4.4),
              child: _catergoriesHeader(context),
            ),
            Padding(
              padding: EdgeInsets.only( top: MediaQuery.of(context).size.height/3.5),
                child: _catergories(context)),
          ],
        ),
      )
    );
  }

  Widget _catergories(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      height: MediaQuery.of(context).size.height/1.8,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      child: StreamBuilder<List<Categories>>(
        stream: database.categoriesStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return PageView.builder(
                controller: _pageViewController,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int Index) {
                  double scale = max(viewportFraction ,(1-(pageOffset - Index).abs()) + viewportFraction);
                  return _workoutContainerContent(context, snapshot.data[Index].name, snapshot.data[Index].thumbnail, Index, scale);
                });
          } else if(snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _waitContainer(BuildContext context, int index, double scale) {
    return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: 15.0,
                top: 50 - scale * 25,
                bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width/1.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0))
              ),
            ),
          ),
        ]
    );
  }

  Widget _workoutContainerContent(BuildContext context, String name, String thumbnail, int index, double scale) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    var route = {'My Workouts' : CategoryMyWorkouts(),
                      'Functional' : FunctionalWorkoutsPage(),
                      'Mobility' : MobilityWorkoutsPage(),};
    return Center(
        child:
          Padding(
            padding: EdgeInsets.only(
                right: 20.0,
                top: 50 - scale * 25,
                bottom: 10.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MultiProvider(
                        providers: [
                          Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                          ChangeNotifierProvider(create: (context) => CTabBarIndex(context: context)),
                        ],
                        child: route[name]);
                  },
                ),
              ),
                child: NeoContainer(
                  gradientColor1: Theme.of(context).primaryColor,
                  gradientColor2: Theme.of(context).primaryColor,
                  gradientColor3: Theme.of(context).primaryColor,
                  gradientColor4: Theme.of(context).primaryColor,
                  containerHeight: MediaQuery.of(context).size.height/2,
                  containerWidth: MediaQuery.of(context).size.width,
                  shadowColor1: Colors.white30,
                  shadowColor2: Colors.black,
                  shadow2Offset: 2.0,
                  shadow1Offset: -3.0,
                  spreadRadius1: 1.0,
                  spreadRadius2: 3.0,
                  blurRadius1: 3.0,
                  blurRadius2: 3.5,
                  circleShape: false,
                  borderColor: Colors.black,
                  containerBorderRadius: BorderRadius.all(Radius.circular(35.0)),
                  containerChild: Container(
                    width: MediaQuery.of(context).size.width/1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(35.0))
                      ),
                      child: Center(
                        child: Text(name.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'FiraSansExtraCondensed',
                          fontSize: 30.0,
                          color: Colors.white
                        ),),
                      ),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(thumbnail),
                            fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(35.0))
                    ),
                  ),
                ),
              ),
            ),

    );
  }

  Widget _catergoriesHeader(BuildContext context) {
    return Text('Kategorien'.toUpperCase(),
    style: TextStyle(
      fontFamily: 'FiraSansExtraCondensed',
      fontSize: 30.0,
      color: Colors.white
    )
    );
  }

  Widget _header(BuildContext context) {
    return Image(
      image: AssetImage(
        'assets/Exopek_Logo.png'
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return MultiProvider(
                              providers: [
                                Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                                ChangeNotifierProvider(create: (context) => CTabBarIndex(context: context)),
                                ChangeNotifierProvider(create: (context) => navbarColor()),
                              ],
                              child: StatisticAPage());
                        },
                      ),
                    );
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
