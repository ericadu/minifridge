import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/services/user_item_api.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class HomeArguments {
  final String uid;

  HomeArguments(this.uid);
}

class HomePage extends StatelessWidget {
  final FirebaseUser user;
  const HomePage({Key key, this.user}) : super(key: key);
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

  List<int> _getDates() {
    return List.generate(foods.length, (_) => rand.nextInt(14));
  }

  SliverChildBuilderDelegate _buildItemsDelegate(BuildContext context) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return ListTile(
          title: Text(foods[index]),
          subtitle: Text(_getDates()[index].toString() + " days")
        );
      },
      childCount: foods.length
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserItemsApi _userItemsApi = UserItemsApi(user.uid);

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
                onPressed: () => Provider.of<UserNotifier>(context, listen: false).signOut(),
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