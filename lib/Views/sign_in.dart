

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/CustomWidgets/custom_rect_tween.dart';
import 'package:video_app/CustomWidgets/custom_signIn_Button.dart';
import 'package:video_app/Helpers/blank.dart';
import 'package:video_app/Helpers/hero_dialog_route.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/listViewIndex.dart';
import 'package:video_app/Notifyers/navigationBar_notifyer.dart';
import 'package:video_app/Notifyers/sortBar_notifyer.dart';
import 'package:video_app/Notifyers/tabbar_color.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Services/firebase_auth_service.dart';
import 'package:video_app/Services/storage_handler.dart';
import 'package:video_app/Views/create_account.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'center_a.dart';


class SignInPage extends StatefulWidget {

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future<OwnUser> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      final user = await auth.signInWithGoogle();
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<OwnUser> _signInwithEmail(BuildContext context, email, String password) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      final user = await auth.signInWithEmail(email, password);
      return user;
    } catch (e) {
      print(e);
    }
  }

  //ToDo: dispose controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
                child: Stack(
                  children: [
                   Container(
                     height: MediaQuery.of(context).size.height,
                     width: MediaQuery.of(context).size.width,
                     child: Image(
                          image: AssetImage(
                            'assets/Thabs.png',
                          ),
                       fit: BoxFit.cover,
                        ),
                   ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height/3.5),
                      //FlutterLogo(size: 150),
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8, right: MediaQuery.of(context).size.width/8),
                        child: _header(context),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/15),
                      _signInButtonEmail(context),
                      //SizedBox(height: MediaQuery.of(context).size.height/100),
                      //_testButton(context),
                      //_signInButton(context),
                      //SizedBox(height: MediaQuery.of(context).size.height/15),
                      _createAccountButton(context)
                    ],
                  ),
                  ]
                ),
              ),


    );
  }

  Widget _header(BuildContext context) {
    return Text('WELCOME TO THE FUTURE OF FUNCTIONAL TRAINING',
      style: TextStyle(
        fontFamily: 'FiraSansExtraCondensed',
        fontSize: 30,
        color: Colors.white
      ),
    );

  }

  Widget _signInButtonEmail(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/2.6,
      width: MediaQuery.of(context).size.width/1.5,
      child: Column(
          children: [
            SizedBox(height: 20.0,),
            Container(
                  height: MediaQuery.of(context).size.height/14.0,
                  width: MediaQuery.of(context).size.width/1.4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      border: Border.all(
                          color: Colors.grey
                      )
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: '  Deine E-Mail',
                        hintStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        border: InputBorder.none
                      ),
                      style: TextStyle(
                          color: Colors.black
                      ),
                      controller: emailController,
                    ),
                  ),
                ),),

            SizedBox(height: 20.0,),
            Container(
                height: MediaQuery.of(context).size.height/14.0,
                width: MediaQuery.of(context).size.width/1.4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  border: Border.all(
                    color: Colors.grey
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.start,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '  Deine Passwort',
                          hintStyle: TextStyle(
                            color: Colors.black54
                          ),
                          border: InputBorder.none
                      ),
                      style: TextStyle(
                        color: Colors.black
                      ),
                      controller: passwordController,
                    ),
                  ),
                ),),
            SizedBox(height: MediaQuery.of(context).size.height/50,),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: AddTodoButton(email: emailController.text, password: passwordController.text),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
              child: _signInButton(context),
            )
            /*
            OutlineButton(
              splashColor: Colors.redAccent,
              onPressed: () {
                _signInwithEmail(context, emailController.text, passwordController.text).then((result) {
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
                              ],
                              child: HomePageMusikStyle());
                        },
                      ),
                    );
                  }
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.grey),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Email',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            */
          ],
        ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height*0.06,
        width: MediaQuery.of(context).size.width*0.47,

      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            primary: Colors.grey.withOpacity(0.4),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(35))),
            side: BorderSide(color: Colors.grey)
        ),
        onPressed: () {
          try {
            _signInWithGoogle(context).then((result) {
              if (result != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MultiProvider(
                          providers: [
                            Provider(create: (context) => StorageHandler(uid: result.uid),),
                            Provider(create: (context) => DatabaseHandler(uid: result.uid),),
                            ChangeNotifierProvider(create: (context) => TabbarColor(context: context)),
                            ChangeNotifierProvider(create: (context) => ButtonbarColor(context: context)),
                            ChangeNotifierProvider(create: (context) => ListViewIndex(context: context)),
                            ChangeNotifierProvider(create: (context) => navbarColor()),
                          ],
                          child:  CenterAPage());
                    },
                  ),
                );
              }

                //throw(result.toString());
            });

          } catch (e) {
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return _AddTodoPopupCard();
            }));
          }
        },
        child: Center(
          child: Text(
            'Sign in with Google',
            style: TextStyle(
              //fontSize: MediaQuery.of(context).size.width*0.06,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      )

            // Image(image: AssetImage("assets/google_logo.png"), height: 35.0),

    );
  }


  Widget _testButton(BuildContext context) {
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
           // _signInWithGoogle(context).then((result) {
            //  if (result != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MultiProvider(
                          providers: [
                            Provider(create: (context) => StorageHandler(uid: ''),),
                            Provider(create: (context) => DatabaseHandler(uid: ''),),
                            ChangeNotifierProvider(create: (context) => TabbarColor(context: context)),
                            ChangeNotifierProvider(create: (context) => ButtonbarColor(context: context)),
                            ChangeNotifierProvider(create: (context) => ListViewIndex(context: context)),
                            ChangeNotifierProvider(create: (context) => navbarColor()),
                          ],
                          child:  CenterAPage());
                    },
                  ),
                );
           //   }
          // });
          },
          child: Center(
            child: Text(
              'Test',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
        )

      // Image(image: AssetImage("assets/google_logo.png"), height: 35.0),

    );
  }

  Widget _createAccountButton(BuildContext context) {
    return Container(
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Du bist nicht registriert?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),),
          TextButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(5.0),
            ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CreateUserAccountPage();
                  },
                ),
              ),
              child: Text('Registrieren',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19.0
              ),))
        ],
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
            color: Colors.redAccent.withOpacity(0.8),
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
                        'Falsche Passwort oder Email'
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
