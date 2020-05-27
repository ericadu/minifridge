import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/main.dart';

class HomeArguments {
  final String uid;

  HomeArguments(this.uid);
}

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final HomeArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().then((res) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              });
            }
          )
        ],
      ),
      body: Center(child: Text('Welcome!')),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Home Page'),
    //     actions: <Widget>[
    //       FlatButton(
    //         child: Text(
    //           'Logout',
    //           style: TextStyle(
    //             fontSize: 18.0,
    //             color: Colors.white,
    //           ),
    //         ),
    //         onPressed: _signOut,
    //       ),
    //     ],
    //   ),
    //   body: Center(child: Text('Welcome!')),
    // );
  }
}