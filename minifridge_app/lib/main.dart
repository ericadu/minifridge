import 'package:flutter/material.dart';
import 'package:minifridge_app/providers/reports_notifier.dart';
import 'package:minifridge_app/screens/add_item/image_upload.dart';
import 'package:minifridge_app/screens/landing.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:minifridge_app/screens/base_items/base_items.dart';
import 'package:minifridge_app/services/amplitude.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense("NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmg2ITowMn0wfTcmEzQ+Mjo/fTA8Pg==");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthNotifier.instance(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportsNotifier()
        ),
        Provider(
          create: (_) => AnalyticsService()
        ),
      ],
      child: MaterialApp(
        title: 'foodbase',
        theme: AppTheme.lightTheme,
        home: LandingPage(),
        // navigatorObservers: [
        //   observer
        // ],
        routes: <String, WidgetBuilder> {
          HomePage.routeName: (BuildContext context) => HomePage(),
          BaseItemsPage.routeName: (BuildContext context) => BaseItemsPage(),
          ImageUploadPage.routeName: (BuildContext context) => ImageUploadPage(),
        },
      )
    );
  }
}

