import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/Helpers/helpers.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Services/firebase_auth_service.dart';
import 'package:video_app/Services/storage_handler.dart';
import 'package:video_app/Views/login.dart';
import 'package:video_app/Views/sign_in.dart';
import 'package:video_app/login_service.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);
    final StorageHandler storage = Provider.of<StorageHandler>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profil',
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int Index) {
              return Container(
                height: MediaQuery.of(context).size.height/1.1,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                            child: StreamBuilder(
                              stream: storage.getProfilImage(),
                                builder: (_, AsyncSnapshot<DownloadUrl> snapshot2){
                                  if (snapshot2.hasData) {
                                    return InkWell(
                                      onTap: () async {
                                        final pickedImage = await HelperFunctions().pickImage();
                                        File UserImage = File(pickedImage.path);
                                        await storage.uploadProfilImage(UserImage);
                                      },
                                      child: Container(
                                        height: 90.0,
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    snapshot2.data.downloadUrl
                                                )
                                            )
                                        ),

                                        /*Consumer<FirebaseAuthService>(
                                      builder: (context, data, child) {
                                        var userData = data.onAuthStateChanged;
                                        print(userData.first.);
                                        return Text(data.userData.toString());
                                      }),
                                      */

                                      ),
                                    );
                                  } else if (snapshot2.hasError) {
                                    return StreamBuilder<OwnUser>(
                                    stream: auth.onAuthStateChanged,
                                    builder: (_, AsyncSnapshot<OwnUser> snapshot) {
                                      if (snapshot.hasData && snapshot.data.foto != null) {
                                      return InkWell(
                                        onTap: () async {
                                          final pickedImage = await HelperFunctions().pickImage();
                                          File UserImage = File(pickedImage.path);
                                          await storage.uploadProfilImage(UserImage);
                                        },
                                        child: Container(
                                          height: 90.0,
                                          width: 90.0,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      snapshot.data.foto
                                                  )
                                              )
                                          ),

                                          /*Consumer<FirebaseAuthService>(
                                      builder: (context, data, child) {
                                        var userData = data.onAuthStateChanged;
                                        print(userData.first.);
                                        return Text(data.userData.toString());
                                      }),
                                      */

                                        ),
                                      );
                                      } else {
                                        return InkWell(
                                          onTap: () async {
                                            final pickedImage = await HelperFunctions().pickImage();
                                            File UserImage = File(pickedImage.path);
                                            await storage.uploadProfilImage(UserImage);
                                          },
                                          child: Container(
                                            height: 90.0,
                                            width: 90.0,
                                            child: Icon(Icons.camera_alt_rounded,
                                              color: Colors.white,),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey[900]
                                          ),
                                        )
                                        );
                                      }
                                    });
                                  } else {
                                    return InkWell(
                                      onTap: () async {
                                        final pickedImage = await HelperFunctions().pickImage();
                                        File UserImage = File(pickedImage.path);
                                        await storage.uploadProfilImage(UserImage);
                                      },
                                      child: Container(
                                        height: 90.0,
                                        width: 90.0,
                                        child: Icon(Icons.camera_alt_rounded,
                                        color: Colors.white,),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[900]
                                            /*
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    snapshot.data.foto
                                                )
                                            )

                                             */
                                        ),

                                        /*Consumer<FirebaseAuthService>(
                                      builder: (context, data, child) {
                                        var userData = data.onAuthStateChanged;
                                        print(userData.first.);
                                        return Text(data.userData.toString());
                                      }),
                                      */

                                      ),
                                    );
                                  }
                                }
                                )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: StreamBuilder<OwnUser>(
                          stream: auth.onAuthStateChanged,
                          builder: (_, AsyncSnapshot<OwnUser> snapshot) {
                            if (snapshot.hasData && snapshot.data.name != null) {
                              return Text(snapshot.data.name,
                                style: TextStyle(
                                  color: Colors.white,
                                    fontSize: 25,
                                  fontWeight: FontWeight.bold
                                ),);
                            } else {
                              return Text('Hallo',
                                style: TextStyle(
                                    fontSize: 25
                                ),);
                            }
                          }
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height/2,),
                      child: Container(
                        height: MediaQuery.of(context).size.height/10,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.2, 0.4, 0.9],
                              colors: [Colors.red, Colors.red[700], Colors.red[900]]
                          ),
                        ),
                        child: OutlineButton(
                          color: Colors.black,
                          onPressed: ()  {
                            signOutGoogle().then((result) {
                              if (result != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SignInPage();
                                    },
                                  ),
                                );
                              }
                            });
                          },
                          child: Text('LogOut',
                          style: TextStyle(
                            fontSize: 25,
                                color: Colors.white
                          ),),
                        ),
                      ))
                    ],
                  ),

              );
            })

    );
  }
}

