import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_app/Models/models.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> updateData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);

  }

  Future<void> deleteData({String path, String docName}) async {
    final reference = FirebaseFirestore.instance.collection(path);
    await reference.doc(docName).delete();
  }

  Future<T> getDataMap<T>({@required String path,@required builder(data)}) async {
    //Routine newRoutine;
    //var dataMap = new Map();
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = await reference.get();
    //newRoutine = Routine.fromMap(snapshots.data()); // Daten in das Model geben
    //print(newRoutine);
    //dataMap = {'workoutNames': newRoutine.workoutNames, 'videoPaths': newRoutine.videoPaths};
    return builder(snapshots.data());

  }

  Future<List<T>> getData<T>({@required String path,}) async {
    RoutineAnimation newRoutine;
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = await reference.get();
     newRoutine = RoutineAnimation.fromMap(snapshots.data());
     print(newRoutine);
     return newRoutine.workout;

  }

  Future<void> transactionData({String path, List<dynamic> data, List<dynamic> thumb, List<dynamic> artboard, List<dynamic> muscle, List<dynamic> level}) async {
    RoutineAnimation newRoutine;
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.get();
    snapshots.then((docSnapshot) => {
      newRoutine = RoutineAnimation.fromMap(docSnapshot.data()),
      data.forEach((element) {
        newRoutine.workout.add(element);
      }),
      thumb.forEach((element) {
        newRoutine.thumbnail.add(element);
      }),
      artboard.forEach((element) {
        newRoutine.artboard.add(element);
      }),
      muscle.forEach((element) {
        newRoutine.muscle.add(element);
      }),
      level.forEach((element) {
        newRoutine.level.add(element);
      }),
      reference.set(newRoutine.toMap())
    });

  }

  Future<void> transactionWorkoutData({String path, RoutineAnimation data}) async {  // hier stand List<dynamic> data
    RoutineAnimation newRoutine;
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.get();
    snapshots.then((docSnapshot) => {
      newRoutine = RoutineAnimation.fromMap(docSnapshot.data()),
      //newRoutine.workoutNames.replaceRange(0, newRoutine.workoutNames.length, data),

      reference.set(data.toMap()) // hier stand vorher newroutine
    });

  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map(
          (snapshot) =>builder(snapshot.data()),
    ).toList());
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required String docPath,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = FirebaseFirestore.instance.collection(path).doc(docPath);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data()));
  }


}