import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_thumbnail/video_thumbnail.dart';



class FirebaseStorageService {

  FirebaseStorageService._();
  static final instance = FirebaseStorageService._();


  Future<void> uploadImageToStorage({String path, File imageFile}) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(imageFile);
  }

  Stream<DownloadUrl> downloadUrl({@required String path}) async*{
    final ref = FirebaseStorage.instance.ref();
    final pathReference = ref.child(path);
    String downloadUrl = await pathReference.getDownloadURL();
    if (downloadUrl != null) {
      yield DownloadUrl(downloadUrl: downloadUrl);
    } else {
      yield null;
    }
  }

  Future<Map> videoDownload(BuildContext context, String path) async{
    var videoUrls = new List();
    var pathInfo = new List();
    var thumbnails = new List();
    var videoInfoMap = new Map();
    final _ref = FirebaseStorage.instance.ref();
    final _pathReference = _ref.child(path).listAll();
    final sol = await _pathReference;
    final sol1 = sol.items.asMap();

    for (var i = 0; i < sol1.length; i++) {
      final _pathReferenceVideo = _ref.child(sol1[i].fullPath);
      String downloadUrl = await _pathReferenceVideo.getDownloadURL();
      videoUrls.add(downloadUrl);
      pathInfo.add(sol1[i].fullPath);
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: downloadUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
      thumbnails.add(thumbnail);
    }
    videoInfoMap['videoUrls'] = videoUrls;
    videoInfoMap['pathInfo'] = pathInfo;
    videoInfoMap['thumbnails'] = thumbnails;
    return videoInfoMap;
  }



  /*
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) async* {
    final ref = FirebaseStorage.instance.ref();
    final pathReference = ref.child(path);
    String url = await pathReference.getDownloadURL();
    yield url;
  }

   */






}
