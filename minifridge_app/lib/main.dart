import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/landing.dart';
import 'package:minifridge_app/screens/login.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:minifridge_app/screens/settings.dart';
import 'package:minifridge_app/screens/signup.dart';
import 'package:minifridge_app/screens/user_items/user_items.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minifridge',
      theme: AppTheme.lightTheme,
      home: LandingPage(),
      navigatorObservers: [
        observer
      ],
      routes: <String, WidgetBuilder> {
        HomePage.routeName: (BuildContext context) => HomePage(),
        UserItemsPage.routeName: (BuildContext context) => UserItemsPage(),
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        SignupPage.routeName: (BuildContext context) => SignupPage(),
        SettingsPage.routeName: (BuildContext context) => SettingsPage()
      },
    );
  }
}

