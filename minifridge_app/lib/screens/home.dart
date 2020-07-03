import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifridge_app/screens/add_item/image_upload.dart';
import 'package:minifridge_app/screens/user_items/user_items.dart';
import 'package:minifridge_app/services/user_items_api.dart';
import 'package:minifridge_app/view/image_picker_notifier.dart';
import 'package:minifridge_app/view/user_items_notifier.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  Widget _buildAddButton(BuildContext context, ImagePickerNotifier picker) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.grey[700],
        size: 30
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              color: Color(0xFF737373),
              height: 130,
              child: Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Take photo'),
                      onTap: () {
                        Navigator.pop(context);
                        picker.pickImage(ImageSource.camera);
                      }
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Upload from library'),
                      onTap: () {
                        Navigator.pop(context);
                        picker.pickImage(ImageSource.gallery);
                      }
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.edit),
                    //   title: Text('Enter manually'),
                    //   onTap: () {
                        
                    //   }
                    // )
                  ]
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10)
                  )
                )
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<UserNotifier>(context, listen: false).user;
    final UserItemsApi _userItemsApi = UserItemsApi(user.uid);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImagePickerNotifier()
        ),
        ChangeNotifierProvider(
          create: (_) => UserItemsNotifier(_userItemsApi)
        )
      ],
      child: Consumer(
        builder: (BuildContext context, ImagePickerNotifier picker, _) {
          
          if (picker.hasImage()) {
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
                          onPressed: () => picker.startUpload(user.uid)
                        ),
                    ]
                  )
                ),
                body: ImageUploadPage()
            );
          }

          return Scaffold(
            body: UserItemsPage(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Container(
              width: 70,
              height: 70,
              child: _buildAddButton(context, picker)
            )
          );
        }
      )
    );
  }

}