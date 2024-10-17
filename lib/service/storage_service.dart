// ignore_for_file: empty_catches, unused_catch_clause

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:wbrs/helper/global.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFiles(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage
          .ref(
              '${firebaseAuth.currentUser?.displayName}/$fileName+${firebaseAuth.currentUser?.email}')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {}
  }

  Future<String> downloadUrl(fileName) async {
    String downloadUrl = await storage
        .ref(
            '${firebaseAuth.currentUser?.displayName}/$fileName+${firebaseAuth.currentUser?.email}')
        .getDownloadURL();
    firebaseAuth.currentUser!.updatePhotoURL(downloadUrl);

    return downloadUrl;
  }
}
