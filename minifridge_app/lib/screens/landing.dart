import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:minifridge_app/screens/register.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, AuthNotifier user, _) {
        switch (user.status) {
          case Status.Unauthenticated:
          case Status.Authenticating:
            return RegisterPage();
          case Status.Authenticated:
            return HomePage();
          case Status.Uninitialized:
          default:
            return Splash();
        }
      }
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}