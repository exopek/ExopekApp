import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:video_app/Models/apis.dart';
import 'package:video_app/Models/models.dart';
import 'package:video_app/Services/firebase_storage_service.dart';

class StorageHandler {
  StorageHandler({@required this.uid}) : assert(uid != null);
  final String uid;

  final _storageService = FirebaseStorageService.instance;

  Future<void> uploadProfilImage(File imagefile) async => _storageService.uploadImageToStorage(
    path: StoragePath.profilImage(uid),
    imageFile:  imagefile
  );

  Stream<DownloadUrl> getProfilImage() => _storageService.downloadUrl(
      path: StoragePath.profilImage(uid),
  );
}