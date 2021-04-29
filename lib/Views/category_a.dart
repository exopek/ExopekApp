import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/neoContainer.dart';
import 'package:video_app/Helpers/blank.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/categoryTabBarIndex.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Views/workout_a.dart';

class CategoryAPage extends StatefulWidget {

  final category;
  final routineName;

  const CategoryAPage({Key key,@required this.category, this.routineName}) : super(key: key);

  @override
  _CategoryAPageState createState() => _CategoryAPageState();
}

class _CategoryAPageState extends State<CategoryAPage> {

  List functionalTabBar = ['Squat', 'Lunge', 'Hinge','Push', 'Pull', 'Carry'];

  List excerciseTabBar = ['Alle' ,'Chest', 'Legs', 'Back', 'Shoulders', 'Arms', 'Abs', 'Hamstrings'];

  List konfiguratorTabBar = ['Alle' ,'Chest', 'Legs', 'Back', 'Shoulders', 'Arms', 'Abs', 'Hamstrings'];

  List mobilityTabBar = ['Hips', 'Shoulder', 'Neck', 'Back', 'Legs'];

  var tabBarMap = new Map();

  List currentTabBar = new List();

  List thumbnails = new List();

  List workoutNames = new List();

  bool firstVisit;

  bool _toggled;

  int index;

  var toggleMap = new Map();

  var thumbnailMap = new Map();

  void setFirstTabbarIndex() async {
    final CTabBarIndex tabBarIndex = Provider.of<CTabBarIndex>(context);
    tabBarIndex.updateIndex(0, widget.category,context);
  }

  void initState() {
    var tabBarMap = {'Functional':functionalTabBar, 'Mobility':mobilityTabBar, 'Excercises':excerciseTabBar, 'Konfigurator':konfiguratorTabBar};
    thumbnailMap = {'Bankdrücken': '', 'Schulterpresse': '', 'Butterfly': '', 'CrossPress': '', 'XPushUp': '', 'Seitheben': ''};
    toggleMap = {'Bankdrücken': false, 'Schulterpresse': false, 'Butterfly': false, 'CrossPress': false, 'XPushUp': false, 'Seitheben': false};
    currentTabBar = tabBarMap[widget.category];
    firstVisit = false;
    _toggled = false;
    //setFirstTabbarIndex();
    //index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseHandler database = Provider.of<DatabaseHandler>(context);
    /*
    if (firstVisit == false) {
      final CTabBarIndex tabBarIndex = Provider.of<CTabBarIndex>(context);
      tabBarIndex.updateIndex(0, widget.category,context);
      setState(() {
        firstVisit = true;
      });
    }

     */
    if (widget.category == 'Konfigurator') {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.category),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
            elevation: 0,
          ),
          backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
          bottomNavigationBar: Container(
            height: 50.0,
            child: OutlineButton(

              borderSide: BorderSide(
                color: Colors.white
              ),
              child: Center(
                child: Text(
                  'SPEICHERN',
                  style: TextStyle(
                    fontFamily: 'FiraSansExtraCondensed',
                    color: Colors.white
                  ),
                )
              ),
              onPressed: () {
                toggleMap.forEach((key, value) {
                  if (value == true) {
                    thumbnails.add(thumbnailMap[key]);
                    workoutNames.add(key);
                    database.updateRoutine(workoutNames, thumbnails, widget.routineName);
                  }
                });
                Navigator.pop(context);
              },

            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,),
                  child: _tabBar(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: _listView(context),
                )
              ],
            ),
          )


      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.category),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,),
                  child: _tabBar(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: _listView(context),
                )
              ],
            ),
          )


      );
    }

  }

  Widget _tabBar(BuildContext context) {
    final CTabBarIndex tabBarIndex = Provider.of<CTabBarIndex>(context);
    return Container(
      height: MediaQuery.of(context).size.height/16.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: currentTabBar.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  tabBarIndex.updateIndex(index, widget.category,context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white
                      )
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Center(
                      child: Text(currentTabBar[index],
                        style: TextStyle(
                            fontFamily: 'FiraSansExtraCondensed',
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _listView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Consumer<CTabBarIndex>(
        builder: (context, data, child) {
          return StreamBuilder<List<Workout>>(
            stream: data.cTabBarStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MultiProvider(
                                        providers: [
                                          //Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                                          ChangeNotifierProvider(create: (context) => CTabBarIndex(context: context)),
                                        ],
                                        child: WorkoutAPage(thumbnail: snapshot.data[index].thumbnail, workoutName: snapshot.data[index].workout, videoUrl: snapshot.data[index].videoPath,));
                                  },
                                ),
                              );
                            },
                            child: _listViewInput(context, snapshot.data[index].workout, snapshot.data[index].thumbnail)
                          );
                      }
                      );
                } else {
                  return Container();
                }
              }
              );
        },
      ),
    );
  }

  Widget _listViewInput(BuildContext context, String workoutTag, String thumbnail) {
    if (widget.category == 'Konfigurator') {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/35, left: MediaQuery.of(context).size.width/20, right: MediaQuery.of(context).size.width/20),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          elevation: 5.0,
          shadowColor: Colors.black,
          child: NeoContainer(
            circleShape: false,
            containerHeight: MediaQuery.of(context).size.height/10,
            containerWidth: MediaQuery.of(context).size.width,
            shadowColor1: Colors.black,
            shadowColor2: Colors.grey,
            gradientColor1: Theme.of(context).primaryColor,
            gradientColor2: Theme.of(context).primaryColor,
            gradientColor3: Theme.of(context).primaryColor,
            gradientColor4: Theme.of(context).primaryColor,

            containerBorderRadius: BorderRadius.all(Radius.circular(20.0)),

            containerChild: Center(
              child: SwitchListTile(
                title: Text(workoutTag,
                  style: TextStyle(
                    fontFamily: 'FiraSansExtraCondensed',
                      color: Colors.white
                  ),),
                value: toggleMap[workoutTag],
                onChanged: (bool value) {
                  setState(() {
                    toggleMap[workoutTag] = value;
                    thumbnailMap[workoutTag] = thumbnail;
                  });
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/35, left: MediaQuery.of(context).size.width/20, right: MediaQuery.of(context).size.width/20),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          elevation: 5.0,
          shadowColor: Colors.black,
          child: Container(
            height: MediaQuery.of(context).size.height/5,
            width: MediaQuery.of(context).size.width/1.2,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(35.0))
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35.0))
              ),
              title: Text(workoutTag,
                style: TextStyle(
                    color: Colors.white
                ),),
            ),
          ),
        ),
      );
    }
  }

  Widget _sliverElement(BuildContext context) {
    return Consumer<CTabBarIndex>(
        builder: (context, data, dynamic) {
          return StreamBuilder<List<Workout>>(
            stream: data.cTabBarStream,
              builder: (BuildContext context1, snapshot) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context21, index) {
                        return ListTile(
                            title: Text(snapshot.data[index].workout),
                          );
                      },
                    childCount: snapshot.data.length,
                  ),
                );
              }
              );
        }
        );
  }

  Widget _listItems(BuildContext context) {
    return Consumer<CTabBarIndex>(
      builder: (context, data, child) {
        return StreamBuilder<List<Workout>>(
            stream: data.cTabBarStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data[index].workout,
                            style: TextStyle(
                                color: Colors.black
                            ),),
                        ),
                      );
                    }
                );
              } else {
                return Container();
              }
            }
        );
      },
    );
  }

  Widget _expAppBar(BuildContext context, Widget tabBar) {
    return SliverAppBar(
      leading: IconButton(
          icon: Icon(Icons.filter_1),
          onPressed: () {
            // Do something
          }
      ),
      expandedHeight: 220.0,
      floating: true,
      pinned: true,
      snap: true,
      elevation: 50,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: tabBar,
          background: Image.network(
            'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
            fit: BoxFit.cover,
          )
      ),
    );
  }



}
