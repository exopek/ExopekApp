import 'package:flutter/material.dart';
import 'dart:async';
import '../Models/models.dart';
import '../Models/apis.dart';
import 'firebase_cloud_service.dart';
import 'package:intl/intl.dart';


class DatabaseHandler {
  DatabaseHandler({@required this.uid}) : assert(uid != null);
  final String uid;
  String currentDate() => DateFormat('yyyy-MM-dd-E-hh-mm').format(DateTime.now()).toString();
  //DateTime.now();

  final _service = FirestoreService.instance;

  Future<void> createFavorite(Favorite favorite) async => _service.setData(
    path: CloudPath.setfavorite(uid, favorite.workout),
    data: favorite.toMap(),
  );

  Future<void> createFinishWorkout(FinishRoutineAnimation routine) async => _service.setData(
    path: CloudPath.setfinishworkout(uid, currentDate()),
    data: routine.toMap(),
  );

  Future<void> deleteFavorite(String workoutName) async => _service.deleteData(
    path: CloudPath.getfavorite(uid),
    docName: workoutName
  );

  Future<void> deleteRoutine(String workoutName) async => _service.deleteData(
      path: CloudPath.getroutine(uid),
      docName: workoutName
  );

  Future<void> updateRoutine({List workout, List thumbnail, List artboard, List muscle, List level, String routine}) async => _service.transactionData(
    path: CloudPath.setroutine(uid, routine),
    data: workout,
    thumb: thumbnail,
    artboard: artboard,
    muscle: muscle,
    level: level
  );

  Future<void> updateRoutineWorkoutList(RoutineAnimation routine, String routineName) async => _service.transactionWorkoutData(
      path: CloudPath.setroutine(uid, routineName),
      data: routine,
  );

  Future<void> createRoutine(RoutineAnimation routine) async => _service.setData(
    path: CloudPath.setroutine(uid, routine.routine),
    data: routine.toMap(),
  );

  Future<dynamic> getRoutine(String routineName) async => _service.getData(
    path: CloudPath.setroutine(uid, routineName),
    //builder: (data) => Routine.fromMap(data),
      );

  Future<dynamic> getRoutineCustomMap(String routineName) async => _service.getDataMap(
    path: CloudPath.setroutine(uid, routineName),
    builder: (data) => RoutineAnimation.fromMap(data),
  );

  Future<dynamic> getFunctionalWorkoutsMap(String routineName) async => _service.getDataMap(
    path: CloudPath.functionalworkouts(routineName),
    builder: (data) => RoutineAnimation.fromMap(data),
  );

  Future<dynamic> getMobilityWorkoutsMap(String routineName) async => _service.getDataMap(
    path: CloudPath.mobilityworkouts(routineName),
    builder: (data) => RoutineAnimation.fromMap(data),
  );

  Stream<List<Favorite>> favoriteStream() => _service.collectionStream(
    path: CloudPath.getfavorite(uid),
    builder:  (data) => Favorite.fromMap(data),
  );

  Stream<List<Workout>> workoutStream() => _service.collectionStream(
    path: CloudPath.getworkouts(),
    builder:  (data) => Workout.fromMap(data),
  );

  Stream<List<RoutineAnimation>> routineStream() => _service.collectionStream(
    path: CloudPath.getroutine(uid),
    builder:  (data) => RoutineAnimation.fromMap(data),
  );

  Stream<List<FinishRoutineAnimation>> verlaufStream() => _service.collectionStream(
    path: CloudPath.getverlauf(uid),
    builder:  (data) => FinishRoutineAnimation.fromMap(data),
  );

  Stream<Routine> routineInputStream(String id) => _service.documentStream(
    path: CloudPath.getroutineinput(uid, id),
    builder:  (data) => Routine.fromMap(data),
    docPath: id,
  );

  Stream<List<WorkoutAnimation>> legWorkoutStream() => _service.collectionStream(
    path: CloudPath.getlegworkouts(),
    builder:  (data) => WorkoutAnimation.fromMap(data),
  );

  Stream<List<WorkoutAnimation>> chestWorkoutStream() => _service.collectionStream(
    path: CloudPath.getchestworkouts(),
    builder:  (data) => WorkoutAnimation.fromMap(data),
  );

  Stream<List<WorkoutAnimation>> allWorkoutStream() => _service.collectionStream(
    path: CloudPath.getallworkouts(),
    builder:  (data) => WorkoutAnimation.fromMap(data),
  );

  Stream<List<Categories>> categoriesStream() => _service.collectionStream(
    path: CloudPath.getcatergories(),
    builder:  (data) => Categories.fromMap(data),
  );

  Stream<List<RoutineAnimation>> functionalStream() => _service.collectionStream(
    path: CloudPath.getfunctionalworkouts(),
    builder:  (data) => RoutineAnimation.fromMap(data),
  );

  Stream<List<RoutineAnimation>> mobilityStream() => _service.collectionStream(
    path: CloudPath.getmobilityworkouts(),
    builder:  (data) => RoutineAnimation.fromMap(data),
  );
}
