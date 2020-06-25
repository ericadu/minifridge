
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifridge_app/screens/add_item/uploader.dart';

class ImageCapture extends StatefulWidget {
  static final routeName = '/image';
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {

  File _imageFile;
  final picker = ImagePicker();

  Future _pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  Widget _renderHasImage() {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Image.file(_imageFile)
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Icon(Icons.refresh),
              onPressed: _clear,
            )
          ]
        ),
        Padding(
          padding: const EdgeInsets.all(50),
          child: Uploader(file: _imageFile)
        )
      ]
    );
  }

  Widget _renderEmpty() {
    return Container(
      height: 500,
      alignment: Alignment(0.0, 0.0),
      child: Text("No image selected 📸")
    );
  }

  Widget _renderBody() {
    if (_imageFile != null) {
      return _renderHasImage();
    } else {
      return _renderEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('Add items')
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery)
            )
          ]
        )
      ),
      body: _renderBody()
    );
  }
}