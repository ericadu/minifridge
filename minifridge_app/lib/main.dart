import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/landing.dart';
import 'package:minifridge_app/screens/login.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:minifridge_app/screens/register.dart';
import 'package:minifridge_app/screens/signup.dart';
import 'package:minifridge_app/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minifridge',
      theme: AppTheme.lightTheme,
      home: LandingPage(),
      routes: <String, WidgetBuilder> {
        HomePage.routeName: (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
        '/signup': (BuildContext context) => SignupPage(),
      }
    );
  }
}

