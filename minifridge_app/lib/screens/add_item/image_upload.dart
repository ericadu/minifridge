import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifridge_app/screens/add_item/uploader.dart';
import 'package:minifridge_app/view/image_picker_notifier.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class ImageUploadPage extends StatelessWidget {
  static final routeName = '/image';

  @override
  Widget build(BuildContext context) {

    return Consumer2(
        builder: (BuildContext context, ImagePickerNotifier picker, UserNotifier user, _) {
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
            body: picker.uploading() ? 
            Uploader()
            : Container(
              padding: EdgeInsets.all(50),
              height: 600,
              child: Image.file(picker.imageFile)
            ),
          );
        }
      );
  }
}