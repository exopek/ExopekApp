import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Notifyers/listViewIndex.dart';
import 'package:video_app/Notifyers/tabbar_color.dart';
import 'package:video_app/Services/database_handler.dart';
import 'package:video_app/Services/firebase_auth_service.dart';
import 'package:video_app/Services/storage_handler.dart';
import 'package:video_app/Views/center_a.dart';
import 'package:video_app/Views/home_a.dart';


class CreateUserAccountPage extends StatelessWidget {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<OwnUser> _createUser(BuildContext context, String email, String password) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      final user = await auth.createUserAccount(email, password);
      return user;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
                  child: Image(
                      image: AssetImage(
                        'assets/Exopek_Logo.png'
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: Center(
                      child: Image(
                        image: AssetImage(
                          'assets/Logo_weiß.png'
                        ),
                      ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 200.0),
                  child: Center(child: _signInButtonEmail(context)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInButtonEmail(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/3.0,
      width: MediaQuery.of(context).size.width/1.5,
      child: Column(
        children: [
          SizedBox(height: 20.0,),
          Container(
            height: MediaQuery.of(context).size.height/17.0,
            width: MediaQuery.of(context).size.width/1.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                border: Border.all(
                    color: Colors.grey
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Deine E-Mail',
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.black54
                      ),
                      border: InputBorder.none
                  ),
                  style: TextStyle(
                      color: Colors.white
                  ),
                  controller: emailController,
                ),
              ),
            ),),

          SizedBox(height: 20.0,),
          Container(
            height: MediaQuery.of(context).size.height/17.0,
            width: MediaQuery.of(context).size.width/1.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                border: Border.all(
                    color: Colors.grey
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                      hintText: 'Deine Passwort',
                      hintStyle: TextStyle(
                          color: Colors.black54
                      ),
                      border: InputBorder.none
                  ),
                  style: TextStyle(
                      color: Colors.white
                  ),
                  controller: passwordController,
                ),
              ),
            ),),
          SizedBox(height: MediaQuery.of(context).size.height/50,),
          OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
              _createUser(context, emailController.text, passwordController.text).then((result) {
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
                            child: CenterAPage());
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
        ],
      ),
    );
  }

}
