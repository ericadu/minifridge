import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifridge_app/screens/add_item/uploader.dart';
import 'package:minifridge_app/view/image_picker_notifier.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class ImageCapture extends StatelessWidget {
  static final routeName = '/image';

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<UserNotifier>(context, listen: false).user;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImagePickerNotifier()
        )
      ],
      child: Consumer(
        builder: (BuildContext context, ImagePickerNotifier picker, _) {
          if (picker.hasImage()) {
            return Scaffold (
              appBar: AppBar(
                title: Text('Selected Photo')
              ),
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.cloud_upload),
                      onPressed: () => picker.startUpload(user.uid)
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => picker.clear()
                    )
                  ]
                )
              ),
              body: picker.uploading() ? 
              Uploader()
              : Container(
                padding: EdgeInsets.all(50),
                height: 600,
                child: Image.file(picker.imageFile)
              ),
            );
          } else {
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
                      onPressed: () => picker.pickImage(ImageSource.camera),
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: () => picker.pickImage(ImageSource.gallery)
                    ),
                  ]
                )
              ),
              body: Container(
                height: 600,
                alignment: Alignment(0.0, 0.0),
                child: Text("No image selected 📸")
              )
            );
          }
        }
      )
    );
  }
}