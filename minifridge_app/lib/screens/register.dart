import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:minifridge_app/providers/user_notifier.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/register';
  // TODO: Fix this login bug, not sure what it is yet
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserNotifier>(context);

    Future<String> _authUser(LoginData data) async {
      String message = await user.signIn(data.name, data.password);
      if (message == SUCCESS_MESSAGE) {
        return Future(null);
      }
      return message;
    }

    Future<String> _newUser(LoginData data) async {
      String message = await user.signUp(data.name, data.password);
      if (message == SUCCESS_MESSAGE) {
        return Future(null);
      }
      return message;
    }

    Future<String> _recoverPassword(String email) async {
      return await user.resetPassword(email);
    }

    FormFieldValidator<String> passwordValidator = (String password) {
      if (password.length < 7) {
        return 'Minimum 6 characters.';
      }

      return null;
    };
    
    return FlutterLogin(
      title: 'foodbase',
      logo: "images/logo.png",
      onLogin: _authUser,
      onSignup: _newUser,
      onSubmitAnimationCompleted: (_) => {},
      onRecoverPassword: _recoverPassword,
      passwordValidator: passwordValidator,
      messages: LoginMessages(
        recoverPasswordDescription: "You'll receive an email with instructions on how to reset your password."
      )
    );
  }
}