

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';

class ImagePickerNotifier extends ChangeNotifier {
  File _imageFile;
  StorageUploadTask _uploadTask;

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://minifridge.appspot.com');

  final picker = ImagePicker();

  File get imageFile => _imageFile;
  StorageUploadTask get uploadTask => _uploadTask;

  bool hasImage() => imageFile != null;
  bool uploading() => _uploadTask != null;

  void startUpload(String userId) {
    String filePath = '$userId/images/${DateTime.now()}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
    notifyListeners();
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);

      analytics.logEvent(name: 'add_item', parameters: {
        'source': source == ImageSource.camera ? 'camera' : 'gallery'
      });
      
      notifyListeners();
    }
  }

  void clear() {
    _imageFile = null;
    _uploadTask = null;
    notifyListeners();
  }
}