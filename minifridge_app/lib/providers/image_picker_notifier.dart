import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagePickerNotifier extends ChangeNotifier {
  File _imageFile;
  List<Asset> _images = List<Asset>();
  List<ByteData> _bytes = List<ByteData>();
  StorageUploadTask _uploadTask;
  ImageSource _source;
  int _current = 0;

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://minifridge.appspot.com');

  final picker = ImagePicker();

  File get imageFile => _imageFile;
  StorageUploadTask get uploadTask => _uploadTask;
  ImageSource get source => _source;
  List<Asset> get images => _images;
  List<ByteData> get bytes => _bytes;
  int get current => _current;

  bool hasImage() => imageFile != null || _images.length > 0;
  bool uploading() => _uploadTask != null;

  void startUpload(String userId) {
    String filePath = '$userId/images/${DateTime.now()}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
    notifyListeners();
  }

  void setCurrent(int index) {
    _current = index;
    notifyListeners();
  }

  Future<String> pickImages() async {
    List<Asset> resultList;
    String _error;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images
      );
    } on Exception catch(e) {
      _error = e.toString();
      print(_error);
    }

    if (_error == null) {
      _images = resultList;
      _bytes = await Future.wait(resultList.map((asset) async => await asset.getByteData()));

      notifyListeners();
      return 'None';
    } else {
      return _error;
    }
  }

  Future pickImage(ImageSource source) async {
    _source = source;

    if (source == ImageSource.camera) {
      final pickedFile = await picker.getImage(source: source);

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);

        analytics.logEvent(name: 'add_item', parameters: {
          'source': source == ImageSource.camera ? 'camera' : 'gallery'
        });
        
        notifyListeners();
      }
    } else {
      String error = await pickImages();
      notifyListeners();
    }
  }

  void clear() {
    _imageFile = null;
    _uploadTask = null;
    _images = List<Asset>();
    _bytes = List<ByteData>();
    
    notifyListeners();
  }
}