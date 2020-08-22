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
        if (picker.urls.length == picker.totalImages) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("🥚🎉", style: TextStyle(fontSize: 40))
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                child: Text("Eggs-cellent! Your items are processing and will be added to your base soon.")
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  child: Text("Back to base"),
                  onPressed: () {
                    picker.clear();
                    Navigator.popAndPushNamed(context, HomePage.routeName);
                  },
                )
              )
            ],
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator()
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("Uploading ${picker.currentlyUploading} out of ${picker.totalImages}")
            )
          ],
        );
          // final StorageUploadTask uploadTask = picker.uploadTask;

          // return StreamBuilder<StorageTaskEvent>(
          //   stream: uploadTask?.events,
          //   builder: (context, snapshot) {
          //     var event = snapshot?.data?.snapshot;
          //     double progressPercent = event != null
          //       ? event.bytesTransferred / event.totalByteCount
          //       : 0;

          //     if (uploadTask != null) {
          //       uploadTask.onComplete.then((value) => {
          //         Scaffold.of(context).showSnackBar(
          //           SnackBar(
          //             backgroundColor: Colors.green,
          //             content: Text("Success! 🎉🎉🎉 Your items will be processed and added to your base soon."),
          //             duration: Duration(seconds: 40),
          //             action: SnackBarAction(
          //               label: "Back",
          //               onPressed: () {
          //                 picker.clear();
          //                 Scaffold.of(context).removeCurrentSnackBar();
          //                 Navigator.popAndPushNamed(context, HomePage.routeName);
          //               }
          //             )
          //           )
          //         )
          //       });
          //     }

          //     return LinearProgressIndicator(value: progressPercent);
          //   }
          // );
        }
      );
  }
}