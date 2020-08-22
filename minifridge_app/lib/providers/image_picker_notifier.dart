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
  List<String> _urllist = [];
  ImageSource _source;
  int _current = 0;
  int _currentlyUploading = -1;

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://minifridge.appspot.com');

  final picker = ImagePicker();

  File get imageFile => _imageFile;
  StorageUploadTask get uploadTask => _uploadTask;
  ImageSource get source => _source;
  List<Asset> get images => _images;
  List<ByteData> get bytes => _bytes;
  int get current => _current;
  bool get processing => _images.length > 0 && _bytes.length == 0;
  List<String> get urls => _urllist;
  int get currentlyUploading => _currentlyUploading;
  int get totalImages => _bytes.length > 0 ? _bytes.length : 1;

  bool hasImage() => imageFile != null || _images.length > 0;
  bool uploading() => _uploadTask != null;

  void startUpload(String userId) async {
    _currentlyUploading = 0;
    notifyListeners();
    if (_source == ImageSource.camera) {
      String filePath = '$userId/images/${DateTime.now()}.png';
      _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
      StorageTaskSnapshot downloadUrl = await _uploadTask.onComplete;
      _urllist = [await downloadUrl.ref.getDownloadURL()];
      _currentlyUploading = 1;
      notifyListeners();
    } else {
      await uploadImage(userId);
    }
  }

  Future uploadImage(String userId) async {
    List<int> numUploads = Iterable<int>.generate(_bytes.length).toList();
    DateTime today = DateTime.now();
    String folderPath = '$userId/images/${today.month}-${today.day}-${today.year}/';
    numUploads.forEach((idx) async {
      List<int> imageData = bytes[idx].buffer.asUint8List();
      StorageMetadata metadata = StorageMetadata(contentType: "image/jpeg");
      _uploadTask = _storage.ref().child('$folderPath/$idx.png')
        .putData(imageData, metadata);
      _currentlyUploading = idx + 1;
      notifyListeners();
      StorageTaskSnapshot downloadUrl = await _uploadTask.onComplete;
      String _url = await downloadUrl.ref.getDownloadURL();
      _urllist.add(_url);
      notifyListeners();
    });
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
        selectedAssets: images
      );
    } on Exception catch(e) {
      _error = e.toString();
      print(_error);
    }

    if (_error == null) {
      _images = resultList;
      notifyListeners();

      _bytes = await Future.wait(resultList.map((asset) async => await asset.getByteData()));

      notifyListeners();
      return 'None';
    } else {
      return _error;
    }
  }

  Future pickImage(ImageSource source) async {
    _source = source;
    notifyListeners();

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
    _currentlyUploading = -1;
    _images = List<Asset>();
    _bytes = List<ByteData>();
    _source = null;
    _urllist = [];
    
    notifyListeners();
  }
}