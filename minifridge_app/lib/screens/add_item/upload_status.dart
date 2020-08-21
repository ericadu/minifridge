import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:provider/provider.dart';

class UploadStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, ImagePickerNotifier picker, _) {
          final StorageUploadTask uploadTask = picker.uploadTask;

          return StreamBuilder<StorageTaskEvent>(
            stream: uploadTask?.events,
            builder: (context, snapshot) {
              var event = snapshot?.data?.snapshot;
              double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

              if (uploadTask != null) {
                uploadTask.onComplete.then((value) => {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Success! 🎉🎉🎉 Your items will be processed and added to your base soon."),
                      duration: Duration(seconds: 40),
                      action: SnackBarAction(
                        label: "Back",
                        onPressed: () {
                          picker.clear();
                          Scaffold.of(context).removeCurrentSnackBar();
                          Navigator.popAndPushNamed(context, HomePage.routeName);
                        }
                      )
                    )
                  )
                });
              }

              return LinearProgressIndicator(value: progressPercent);
            }
          );
        }
      );
  }
}