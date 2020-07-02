import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifridge_app/screens/user_items/user_items.dart';
import 'package:minifridge_app/services/user_item_api.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/view/image_picker_notifier.dart';
import 'package:minifridge_app/view/user_items_notifier.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  Column _buildBottomNavMenu(ImagePickerNotifier picker) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.photo_camera),
          title: Text('Take photo'),
          onTap: () => picker.pickImage(ImageSource.camera)
        ),
        ListTile(
          leading: Icon(Icons.photo_library),
          title: Text('Upload from library'),
          onTap: () => picker.pickImage(ImageSource.gallery)
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Enter manually'),
          onTap: () {}
        )
      ]
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
          FloatingActionButton addButton = FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    color: Color(0xFF737373),
                    height: 180,
                    child: Container(
                      child: _buildBottomNavMenu(picker),
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
            child: Icon(Icons.add, color: Colors.grey[700]),
          );

          return Scaffold(
            backgroundColor: AppTheme.themeColor,
            body: UserItemsPage(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: addButton
          );
        }
      )
    );
  }

}