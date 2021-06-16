import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/Helpers/blank.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/workout2_a.dart';
import 'package:video_app/Views/workout3_a.dart';
import 'package:video_app/Views/workout_a.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FunctionalWorkoutsPage extends StatelessWidget {

  ScrollController myWorkoutsController = ScrollController();

  BouncingScrollPhysics myWorkoutsPhysics = BouncingScrollPhysics();

  String _header = 'Functional';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
        title: Text(
          _header,
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: SafeArea(
          top: false,
          child: _listView(context)),
    );
  }

  Widget _listView(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<RoutineAnimation>>(
        stream: database.functionalStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return  ListView.builder(
                controller: myWorkoutsController,
                physics: myWorkoutsPhysics,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      splashColor: Colors.black,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return MultiProvider(
                                  providers: [
                                    Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                                    //ChangeNotifierProvider(create: (context) => CTabBarIndex(context: context)),
                                  ],
                                  child: Workout3APage(routineName: snapshot.data[index].routineName, category: _header,));
                            },
                          ),
                        );
                      },
                      child: _listViewInput(context, snapshot.data[index].routineName, snapshot.data[index].thumbnails[0])
                  );
                });
          } else {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _listViewInput(BuildContext context, String routineNme, String thumbnail) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01, right: MediaQuery.of(context).size.width*0.02, left: MediaQuery.of(context).size.width*0.02, bottom: MediaQuery.of(context).size.height*0.01),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: NeoContainer(
          circleShape: false,
          containerHeight: MediaQuery.of(context).size.height/5,
          containerWidth: MediaQuery.of(context).size.width,
          shadowColor1: Colors.black,
          shadowColor2: Colors.white,
          gradientColor1: Theme.of(context).primaryColor,
          gradientColor2: Theme.of(context).primaryColor,
          gradientColor3: Theme.of(context).primaryColor,
          gradientColor4: Theme.of(context).primaryColor,
          containerChild: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraSansExtraCondensed',
                          fontSize: 30.0
                      ),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image(
                        height: 40.0,
                        width: 120.0,
                        image: AssetImage(
                          'assets/Exopek_Logo.png',

                        ),
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.17),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: MediaQuery.of(context).size.height/10,
                      width: MediaQuery.of(context).size.width/40,
                      color: Colors.red,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 200,
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), bottomLeft: Radius.circular(15.0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                      child: Image(
                        image: NetworkImage(thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}
