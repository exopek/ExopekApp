import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/Notifyers/categoryTabBarIndex.dart';
import 'package:video_app/Notifyers/infoTextRoutine_notifyer.dart';
import 'package:video_app/Notifyers/navigationBar_notifyer.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/home_a.dart';
import 'package:video_app/Views/myWorkouts_a.dart';
import 'package:video_app/Views/statistic_a.dart';

class CenterAPage extends StatelessWidget {

  var currentTab = [
    HomeAPage(),
    StatisticAPage(),
    MyWorkoutsAPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navbarColor navigationBar = Provider.of<navbarColor>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: _navigationBar(context),
      body: currentTab[navigationBar.index],
    );
  }

  Widget _navigationBar(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    final navbarColor navigationBar = Provider.of<navbarColor>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
      child: NeoContainer(
        circleShape: false,
        shadow2Offset: 2.0,
        shadow1Offset: -3.0,
        spreadRadius1: 1.0,
        spreadRadius2: 3.0,
        blurRadius1: 3.0,
        blurRadius2: 3.5,
        gradientColor1: Theme.of(context).primaryColor,
        gradientColor2: Theme.of(context).primaryColor,
        gradientColor3: Theme.of(context).primaryColor,
        gradientColor4: Theme.of(context).primaryColor,
        shadowColor1: Colors.white30,
        shadowColor2: Colors.black,
        containerWidth: MediaQuery.of(context).size.width/1.2,
        containerHeight: MediaQuery.of(context).size.height/10,
        containerBorderRadius: BorderRadius.all(Radius.circular(40)),
        containerChild: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(0.2)),
                ),
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
                label: Consumer<navbarColor>(
                  builder: (context, data, child) {
                    return Text(
                        'home'.toUpperCase(),
                        style: TextStyle(
                          color: data.navIconColor1
                        ),
                    );
                  }
                )),
            TextButton.icon(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(0.2)),
                ),
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
            TextButton.icon(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(0.2)),
                ),
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
                }
            )
          ],
        ),
      ),
    );
  }
}
