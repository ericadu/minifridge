
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://minifridge.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload(String userId) {
    String filePath = '$userId/images/${DateTime.now()}.png';
    print(filePath);
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<UserNotifier>(context, listen: false).user;
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent = event != null
            ? event.bytesTransferred / event.totalByteCount
            : 0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_uploadTask.isComplete)
                Text('🎉🎉🎉', style: TextStyle(fontSize: 30)),
              if (_uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow, size: 50),
                  onPressed: _uploadTask.resume),
              if (_uploadTask.isInProgress)
                FlatButton(
                  child: Icon(Icons.pause, size: 50),
                  onPressed: _uploadTask.pause),
              
              LinearProgressIndicator(value: progressPercent),
              Text(
                '${(progressPercent * 100).toStringAsFixed(0)} %',
                style: TextStyle(fontSize: 30)
              )
            ]
          );
        }
      );
    } else {
      return FlatButton.icon(
        label: Container(height: 0.0),
        icon: Icon(Icons.cloud_upload),
        onPressed: () => _startUpload(user.uid)
      );
    }
  }
}