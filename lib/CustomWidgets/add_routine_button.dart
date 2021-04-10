import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/listViewIndex.dart';
import 'package:video_app/Notifyers/tabbar_color.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Services/firebase_auth_service.dart';
import 'package:video_app/Services/storage_handler.dart';
import 'package:video_app/Views/dashboard.dart';
import 'package:video_app/Views/home_musik_style.dart';
import '../CustomColors/customColors.dart';
import 'package:video_app/Helpers/hero_dialog_route.dart';

import 'custom_rect_tween.dart';
import '../Helpers/hero_dialog_route.dart';

/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class AddRoutineButton extends StatelessWidget {
  /// {@macro add_todo_button}
  const AddRoutineButton({Key key,@required this.uid,}) : super(key: key);

  final String uid;


  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseHandler>(context, listen: false);
    return Hero(
      tag: _heroAddRoutine,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin, end: end);
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: Container(
          height: 80.0,
          width: 140.0,
          decoration: BoxDecoration(
            //shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Colors.white
            ),
            color: Colors.grey[900]
          ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                      return MultiProvider(
                          providers: [
                            Provider(create: (context) => DatabaseHandler(uid: database.uid),),
                          ],
                          child: const _AddRoutinePopupCard());
                    }
                    )
                    );
                  },
                  /*
                child: Hero(
                  tag: _heroAddRoutine,
                  createRectTween: (begin, end) {
                    return CustomRectTween(begin: begin, end: end);
                  },
                    child: Icon(Icons.add, color: Colors.white,),
                    ),

                 */

                ),
              ]
            ),
            ),
      ),
    );

  }
}

/// Tag-value used for the add todo popup button.
const String _heroAddRoutine = 'add-todo-hero';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Routine]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddRoutine].
/// {@endtemplate}
class _AddRoutinePopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  const _AddRoutinePopupCard({Key key}) : super(key: key);

  Future<Routine> _createRoutine(BuildContext context, String name) async {
    try {
      final database = Provider.of<DatabaseHandler>(context, listen: false);
      List videoPaths = List.generate(0, (index) => '');
      List thumbnails = List.generate(0, (index) => '');
      List workoutNames = List.generate(0, (index) => '');
      await database.createRoutine(Routine(
          routineName: name,
          videoPaths: videoPaths,
          thumbnails: thumbnails,
          workoutNames: workoutNames,
          count: '0'));
    } catch (e) {
      print(e);
    }
  }

  @override
  __AddRoutinePopupCardState createState() => __AddRoutinePopupCardState();
}

class __AddRoutinePopupCardState extends State<_AddRoutinePopupCard> {

  final routineNameController = TextEditingController();
  final routineSizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddRoutine,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.white.withOpacity(0.4),
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: routineNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Gib deiner Routine einen Namen'
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    OutlineButton(
                      color: Colors.grey,
                        splashColor: Colors.grey,
                        onPressed: () {
                          widget._createRoutine(context, routineNameController.text);
                        },
                      child: Center(
                        child: Text('Speichern'.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'FiraSansExtraCondensed',
                          fontSize: 18.0,
                          color: Colors.white
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}