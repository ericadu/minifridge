import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/home.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((res) {
      if (res != null) {
        Navigator.pushReplacementNamed(
          context,
          HomePage.routeName,
          arguments: HomeArguments(res.uid)
        );
      } else {
        Navigator.pushReplacementNamed(context, '/register');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Loading')
    );
  }
}