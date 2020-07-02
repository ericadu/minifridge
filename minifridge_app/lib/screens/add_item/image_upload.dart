import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:minifridge_app/view/image_picker_notifier.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class ImageUploadPage extends StatelessWidget {
  static final routeName = '/image';

  @override
  Widget build(BuildContext context) {

    return Consumer2(
        builder: (BuildContext context, ImagePickerNotifier picker, UserNotifier user, _) {
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
                      backgroundColor: Colors.green[300],
                      content: Text("We've received your items! They'll be processed and added to your base soon 🎉🎉🎉"),
                      action: SnackBarAction(
                        label: "Back to base",
                        onPressed: () {
                          picker.clear();
                          Navigator.pushNamed(context, HomePage.routeName);
                        }
                      )
                    )
                  )
                });
              }

              return Scaffold (
                appBar: AppBar(
                  title: Text('Selected Photo', style: TextStyle(color: Colors.white))
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => picker.clear()
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => picker.startUpload(user.user.uid)
                      ),
                    ]
                  )
                ),
                body: Column(
                  children: [
                    LinearProgressIndicator(value: progressPercent),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 45, horizontal: 40),
                      child: Image.file(picker.imageFile),
                    ),
                  ],
                )
              );
            }
          );
        }
      );
  }
}