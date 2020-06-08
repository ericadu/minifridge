import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/register';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Minifridge",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Roboto')),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: SignInButton(
                Buttons.Email,
                text: "Sign up with Email",
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              )),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: () {},
              )),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                child: Text("Log In Using Email",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue)),
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                }
              )
            )
          ]),
        ));
  }
}