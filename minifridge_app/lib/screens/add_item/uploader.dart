import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/view/image_picker_notifier.dart';
import 'package:provider/provider.dart';

class Uploader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StorageUploadTask uploadTask = Provider.of<ImagePickerNotifier>(context).uploadTask;
    return StreamBuilder<StorageTaskEvent>(
      stream: uploadTask.events,
      builder: (context, snapshot) {
        var event = snapshot?.data?.snapshot;

        double progressPercent = event != null
          ? event.bytesTransferred / event.totalByteCount
          : 0;

        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (uploadTask.isComplete)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('🎉🎉🎉', style: TextStyle(fontSize: 30)),
                ),
              if (uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow, size: 50),
                  onPressed: uploadTask.resume),
              if (uploadTask.isInProgress)
                FlatButton(
                  child: Icon(Icons.pause, size: 50),
                  onPressed: uploadTask.pause),
              
              LinearProgressIndicator(value: progressPercent),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${(progressPercent * 100).toStringAsFixed(0)} %',
                  style: TextStyle(fontSize: 30)
                ),
              ),
              if (uploadTask.isComplete)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                  child: Text("✅ Success! Your items will be processed and added to your base soon.")
                )
            ]
          ),
        );
      }
    );
  }
}
