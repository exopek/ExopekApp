import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OwnUser {
  const OwnUser({@required this.uid, this.email, this.name, this.foto});
  final String uid;
  final String email;
  final String name;
  final String foto;
}
/*
class ImageFile<File> {
  const ImageFile({this.image});
  final File image;
}

 */

class DownloadUrl {
  const DownloadUrl({@required this.downloadUrl});
  final String downloadUrl;
}

class Categories {
  Categories({@required this.name, @required this.thumbnail});

  final String name;
  final String thumbnail;


  factory Categories.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String thumbnail = data['thumbnail'];


    return Categories(
        name: name,
        thumbnail: thumbnail,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'thumbnail': thumbnail,
    };
  }

}

class Favorite {
  Favorite({@required this.videoPath, this.duration, @required this.workout, @required this.level, @required this.thumbnail, @required this.bodyPart});

  final String duration;
  final String videoPath;
  final String workout;
  final String level;
  final String thumbnail;
  final String bodyPart;

  factory Favorite.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String videoPath = data['videoPath'];
    final String duration = data['duration'];
    final String workout = data['workout'];
    final String level = data['level'];
    final String thumbnail = data['thumbnail'];
    final String bodyPart = data['bodyPart'];

    return Favorite(
      videoPath: videoPath,
      duration: duration,
      workout: workout,
      level: level,
      thumbnail: thumbnail,
      bodyPart: bodyPart
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoPath': videoPath,
      'duration': duration,
      'workout': workout,
      'level': level,
      'thumbnail': thumbnail,
      'bodyPart': bodyPart
    };
  }

}

class Workout {
  Workout({@required this.videoPath, @required this.workout, @required this.level, @required this.bodyPart, @required this.thumbnail});

  final String videoPath;
  final String workout;
  final String level;
  final String bodyPart;
  final String thumbnail;

  factory Workout.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String videoPath = data['videoPath'];
    final String workout = data['workout'];
    final String level = data['level'];
    final String bodyPart = data['bodyPart'];
    final String thumbnail = data['thumbnail'];

    return Workout(
        videoPath: videoPath,
        workout: workout,
        level: level,
        bodyPart: bodyPart,
        thumbnail: thumbnail
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoPath': videoPath,
      'workout': workout,
      'level': level,
      'bodyPart': bodyPart,
      'thumbnail': thumbnail
    };
  }

}


class WorkoutAnimation {
  WorkoutAnimation({@required this.artboardName, @required this.workout, @required this.level, @required this.bodyPart, @required this.thumbnail});

  final String artboardName;
  final String workout;
  final String level;
  final String bodyPart;
  final String thumbnail;

  factory WorkoutAnimation.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String artboardName = data['artboardName'];
    final String workout = data['workout'];
    final String level = data['level'];
    final String bodyPart = data['bodyPart'];
    final String thumbnail = data['thumbnail'];

    return WorkoutAnimation(
        artboardName: artboardName,
        workout: workout,
        level: level,
        bodyPart: bodyPart,
        thumbnail: thumbnail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artboardName': artboardName,
      'workout': workout,
      'level': level,
      'bodyPart': bodyPart,
      'thumbnail': thumbnail,
    };
  }

}


class RoutineAnimation {
  RoutineAnimation({@required this.workoutNames, @required this.thumbnails, @required this.routineName, @required this.artboards, @required this.reps, @required this.duration, @required this.muscleGroups, @required this.classifycation});

  final String routineName;
  final List<dynamic> reps;
  final List<dynamic> duration;
  final List<dynamic> artboards;
  final List<dynamic> thumbnails;
  final List<dynamic> workoutNames;
  final List<dynamic> classifycation;
  final List<dynamic> muscleGroups; // bodyParts


  factory RoutineAnimation.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String routineName = data['routineName'];
    final List<dynamic> artboards = data['artboards'];
    final List<dynamic> reps = data['reps'];
    final List<dynamic> duration = data['duration'];
    final List<dynamic> thumbnails = data['thumbnails'];
    final List<dynamic> workoutNames = data['workoutNames'];
    final List<dynamic> classifycation = data['classifycation'];
    final List<dynamic> muscleGroups = data['muscleGroups'];

    return RoutineAnimation(
        artboards: artboards,
        reps: reps,
        duration: duration,
        routineName: routineName,
        thumbnails: thumbnails,
        workoutNames: workoutNames,
        classifycation: classifycation,
        muscleGroups: muscleGroups
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artboards': artboards,
      'reps': reps,
      'duration': duration,
      'routineName': routineName,
      'thumbnails': thumbnails,
      'workoutNames': workoutNames,
      'classifycation': classifycation,
      'muscleGroups': muscleGroups
    };
  }

}


class Routine {
  Routine({@required this.workoutNames, @required this.thumbnails, @required this.routineName, @required this.videoPaths, @required this.count, @required this.muscleGroups, @required this.classifycation});

  final String routineName;
  final String count;
  final List<dynamic> videoPaths;
  final List<dynamic> thumbnails;
  final List<dynamic> workoutNames;
  final List<dynamic> classifycation;
  final List<dynamic> muscleGroups;


  factory Routine.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final List<dynamic> videoPaths = data['videoPaths'];
    final String count = data['count'];
    final String routineName = data['routineName'];
    final List<dynamic> thumbnails = data['thumbnails'];
    final List<dynamic> workoutNames = data['workoutNames'];
    final List<dynamic> classifycation = data['classifycation'];
    final List<dynamic> muscleGroups = data['muscleGroups'];

    return Routine(
        videoPaths: videoPaths,
        count: count,
        routineName: routineName,
        thumbnails: thumbnails,
        workoutNames: workoutNames,
        classifycation: classifycation,
        muscleGroups: muscleGroups
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoPaths': videoPaths,
      'count': count,
      'routineName': routineName,
      'thumbnails': thumbnails,
      'workoutNames': workoutNames,
      'classifycation': classifycation,
      'muscleGroups': muscleGroups
    };
  }

}

class Einheit {
  Einheit({@required this.Datum, @required this.Name, @required this.Dauer, @required this.Thumbnail, @required this.VideoUrl, @required this.Uebungsnamen, @required this.Klassifizierung, @required this.Muskelgruppen});

  final String Datum;
  final String Name;
  final String Dauer;
  final List<dynamic> Thumbnail;
  final List<dynamic> VideoUrl;
  final List<dynamic> Uebungsnamen;
  final List<dynamic> Klassifizierung;
  final List<dynamic> Muskelgruppen;


  factory Einheit.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String Datum = data['Datum'];
    final String Name = data['Name'];
    final String Dauer = data['Dauer'];
    final List<dynamic> Thumbnail = data['Thumbnail'];
    final List<dynamic> VideoUrl = data['VideoUrl'];
    final List<dynamic> Uebungsnamen = data['Uebungsnamen'];
    final List<dynamic> Klassifizierung = data['Klassifizierung'];
    final List<dynamic> Muskelgruppen = data['Muskelgruppen'];

    return Einheit(
        Datum: Datum,
        Name: Name,
        Dauer: Dauer,
        Thumbnail: Thumbnail,
        VideoUrl: VideoUrl,
        Uebungsnamen: Uebungsnamen,
        Klassifizierung: Klassifizierung,
        Muskelgruppen: Muskelgruppen
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Datum': Datum,
      'Name': Name,
      'Dauer': Dauer,
      'Thumbnail': Thumbnail,
      'VideoUrl': VideoUrl,
      'Uebungsnamen': Uebungsnamen,
      'Klassifizierung': Klassifizierung,
      'Muskelgruppen': Muskelgruppen
    };
  }

}

class MyRoutine {
  MyRoutine({@required this.workoutNames, @required this.thumbnails, @required this.routineName, @required this.videoPaths, @required this.count,});

  final String routineName;
  final String count;
  final FieldValue videoPaths;
  final FieldValue thumbnails;
  final FieldValue workoutNames;


  factory MyRoutine.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final FieldValue videoPaths = data['videoPaths'];
    final String count = data['count'];
    final String routineName = data['routineName'];
    final FieldValue thumbnails = data['thumbnails'];
    final FieldValue workoutNames = data['workoutNames'];

    return MyRoutine(
        videoPaths: videoPaths,
        count: count,
        routineName: routineName,
        thumbnails: thumbnails,
        workoutNames: workoutNames
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoPaths': videoPaths,
      'count': count,
      'routineName': routineName,
      'thumbnails': thumbnails,
      'workoutNames': workoutNames
    };
  }

}