import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/register';
  // TODO: Fix this login bug, not sure what it is yet
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserNotifier>(context);

    Future<String> _authUser(LoginData data) async {
      if (!await user.signIn(data.name, data.password)) {
        return 'Something went wrong.';
      }
      
      analytics.logLogin();
      return Future(null);
    }

    Future<String> _newUser(LoginData data) async {
      if (!await user.signUp(data.name, data.password)) {
        return 'Something went wrong.';
      }

      return Future(null);
    }

    
    return FlutterLogin(
      title: 'Later',
      // logo: 'images/minifridge_home_hero.png',
      onLogin: _authUser,
      onSignup: _newUser,
      onSubmitAnimationCompleted: (_) => {},
      onRecoverPassword: (_) => Future(null),
    );
  }
}