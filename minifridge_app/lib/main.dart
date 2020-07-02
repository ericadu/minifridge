import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/add_item/image_upload.dart';
import 'package:minifridge_app/screens/landing.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:minifridge_app/screens/user_items/user_items.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserNotifier.instance(),
        )
      ],
      child: MaterialApp(
        title: 'Minifridge',
        theme: AppTheme.lightTheme,
        home: LandingPage(),
        navigatorObservers: [
          observer
        ],
        routes: <String, WidgetBuilder> {
          HomePage.routeName: (BuildContext context) => HomePage(),
          UserItemsPage.routeName: (BuildContext context) => UserItemsPage(),
          ImageUploadPage.routeName: (BuildContext context) => ImageUploadPage(),
        },
      )
    );
  }
}

