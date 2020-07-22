import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/signed_in_user.dart';
import 'package:minifridge_app/providers/base_items_notifier.dart';
import 'package:minifridge_app/providers/manual_entry_notifier.dart';
import 'package:minifridge_app/screens/add_item/image_upload.dart';
import 'package:minifridge_app/screens/add_item/manual_entry.dart';
import 'package:minifridge_app/screens/base_items/base_items.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/services/push_notifications.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/widgets/add_item_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SignedInUser user;
  bool showManualAdd = false;
  int currentStep = 0;
  bool complete = false;

  void initState() {
    super.initState();
    
    user = Provider.of<AuthNotifier>(context, listen: false).signedInUser;
    final PushNotificationService _notificationService = PushNotificationService(user.id);
     analytics.setUserId(user.id);
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    final FoodBaseApi _baseApi = FoodBaseApi(user.baseId);
   
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImagePickerNotifier()
        ),
        ChangeNotifierProvider(
          create: (_) => BaseItemsNotifier(_baseApi)
        ),
        ChangeNotifierProvider(
          create: (_) => ManualEntryNotifier()
        )
      ],
      child: Consumer2(
        builder: (BuildContext context, ImagePickerNotifier picker, ManualEntryNotifier manual, _) {
          
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
                          onPressed: () => picker.startUpload(user.id)
                        ),
                    ]
                  )
                ),
                body: ImageUploadPage()
            );
          }

          if (manual.showManualAdd) {
            return ManualEntryPage();
          }

          return Scaffold(
            body: BaseItemsPage(api: _baseApi),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Container(
              width: 70,
              height: 70,
              child: AddItemButton()
            )
          );
        }
      )
    );
  }
}