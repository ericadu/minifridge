

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageUploadNotifier extends ChangeNotifier {
  StorageUploadTask _uploadTask;

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://minifridge.appspot.com');

  StorageUploadTask get uploadTask => _uploadTask;

  bool uploading() => _uploadTask != null;

  void startUpload(String userId, File imageFile) {
    String filePath = '$userId/images/${DateTime.now()}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(imageFile);
    notifyListeners();
  }
}