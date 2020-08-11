import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/signed_in_user.dart';
import 'package:minifridge_app/providers/base_notifier.dart';
import 'package:minifridge_app/providers/manual_entry_notifier.dart';
import 'package:minifridge_app/screens/add_item/image_upload.dart';
import 'package:minifridge_app/screens/add_item/manual_entry.dart';
import 'package:minifridge_app/screens/base_items/base_items.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/push_notifications.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SignedInUser user;

  void initState() {
    super.initState();
    
    user = Provider.of<AuthNotifier>(context, listen: false).signedInUser;
    final PushNotificationService _notificationService = PushNotificationService(user.id);
    analytics.setUserId(user.id);
    analytics.logEvent(
      name: 'home_screen', 
      parameters: {'user': user.id}
    );
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImagePickerNotifier()
        ),
        ChangeNotifierProvider(
          create: (_) => BaseNotifier(user)
        ),
        ChangeNotifierProvider(
          create: (_) => ManualEntryNotifier()
        ),
      ],
      child: Consumer2(
        builder: (BuildContext context,
          ImagePickerNotifier picker,
          ManualEntryNotifier manual, _) {
          
          if (picker.hasImage()) {
            return ImageUploadPage();
          }

          if (manual.showManualAdd) {
            return ManualEntryPage();
          }

          return BaseItemsPage();
        }
      )
    );
  }
}