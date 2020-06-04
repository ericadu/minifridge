import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/main.dart';

class HomeArguments {
  final String uid;

  HomeArguments(this.uid);
}

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  static final rand = new Random();

  static final List<String> foods = [
    'Mango',
    'Cilantro',
    'Blueberries',
    'Romaine Lettuce',
    'Bananas',
    'Mushrooms',
    'Cucumbers',
    'Roma Tomatos',
    'Scallions',
    'Lemons', 
    'Limes',
    'Grapes',
    'Avocados'
  ];

  final dates = List.generate(foods.length, (_) => rand.nextInt(14));

  // Widget _buildItemsList(BuildContext context) {
  //   return ListView.separated(
  //     itemCount: foods.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         title: Text(foods[index]),
  //         subtitle: Text(dates[index].toString() + " days")
  //       );
  //     },
  //     separatorBuilder: (context, index) {
  //       return Divider();
  //     },
  //   );
  // }

  SliverChildBuilderDelegate _buildItemsDelegate(BuildContext context) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return ListTile(
          title: Text(foods[index]),
          subtitle: Text(dates[index].toString() + " days")
        );
      },
      childCount: foods.length
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Minifridge'),
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: Placeholder(),
            expandedHeight: 300,
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
          SliverList(
            delegate: _buildItemsDelegate(context)
          )
        ]
      )
    );
  }
}