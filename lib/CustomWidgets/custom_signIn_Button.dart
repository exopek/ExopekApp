import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Helpers/blank.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/listViewIndex.dart';
import 'package:video_app/Notifyers/navigationBar_notifyer.dart';
import 'package:video_app/Notifyers/tabbar_color.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Services/firebase_auth_service.dart';
import 'package:video_app/Services/storage_handler.dart';
import 'package:video_app/Views/center_a.dart';
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
class AddTodoButton extends StatelessWidget {
  /// {@macro add_todo_button}
  const AddTodoButton({Key key,@required this.email,@required this.password}) : super(key: key);

  final String email;
  final String password;

  Future<OwnUser> _signInwithEmail(BuildContext context, email, String password) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      final user = await auth.signInWithEmail(email, password);
      return user;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.06,
      width: MediaQuery.of(context).size.width*0.47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        border: Border.all(
          color: Colors.grey
        )
      ),
      child: GestureDetector(
        onTap: () {
          try {
            _signInwithEmail(context, email, password).then((result) {
              if (result != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MultiProvider(
                          providers: [
                            Provider(create: (context) => StorageHandler(uid: result.uid),),
                            Provider(create: (context) => DatabaseHandler(uid: result.uid),),
                            ChangeNotifierProvider(create: (context) => TabbarColor(context: context)),
                            ChangeNotifierProvider(create: (context) => ListViewIndex(context: context)),
                            ChangeNotifierProvider(create: (context) => navbarColor()),
                          ],
                          child: CenterAPage());
                    },
                  ),
                );
              }
            })
                .catchError((error, stackTrace) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return BlankPage(result: error.toString(),);
                  },
                ),
              );
            });
          } catch (e) {
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return BlankPage(result: e.toString(),);//_AddTodoPopupCard();
            }));
          }


        },
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Container(
            child: Center(
                  child: Text('Sign in with Email',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey
                ),),
              )
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String _heroAddTodo = 'add-todo-hero';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class _AddTodoPopupCard extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  const _AddTodoPopupCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.redAccent,
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sorry da ist etwas schief gelaufen.'
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    const Text(
                      '1. Falsche Passwort oder Email'
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