import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/home.dart';
import 'package:minifridge_app/screens/login.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserNotifier.instance(),
        )
      ],
      child: Consumer(
        builder: (BuildContext context, UserNotifier user, _) {
          switch (user.status) {
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return HomePage(user: user.user);
            case Status.Uninitialized:
            default:
              return Splash();
          }
        }
      )
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