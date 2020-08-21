import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/add_item/upload_status.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:provider/provider.dart';

class ImageUploadPage extends StatelessWidget {
  static final routeName = '/image';

  @override
  Widget build(BuildContext context) {

    return Consumer2(
        builder: (BuildContext context, ImagePickerNotifier picker, AuthNotifier user, _) {

          return Scaffold (
            appBar: AppBar(
              title: Text('Selected Photo', style: TextStyle(color: Colors.white))
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (!picker.uploading())
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => picker.clear()
                    ),
                  if (!picker.uploading())
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => picker.startUpload(user.user.uid)
                    ),
                ]
              )
            ),
            body: Column(
              children: [
                UploadStatus(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                  child: Image.file(picker.imageFile),
                ),
              ],
            )
          );
        }
      );
  }
}