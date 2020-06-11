import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/services/user_item_api.dart';
import 'package:minifridge_app/view/user_items_notifier.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final FirebaseUser user;
  const HomePage({Key key, this.user}) : super(key: key);
  static const routeName = '/home';

  // static final rand = new Random();

  // static final List<String> foods = [
  //   'Mango',
  //   'Cilantro',
  //   'Blueberries',
  //   'Romaine Lettuce',
  //   'Bananas',
  //   'Mushrooms',
  //   'Cucumbers',
  //   'Roma Tomatos',
  //   'Scallions',
  //   'Lemons', 
  //   'Limes',
  //   'Grapes',
  //   'Avocados'
  // ];

  // List<int> _getDates() {
  //   return List.generate(foods.length, (_) => rand.nextInt(14));
  // }

  // SliverChildBuilderDelegate _buildItemsDelegate(BuildContext context) {
  //   return SliverChildBuilderDelegate(
  //     (BuildContext context, int index) {
  //       return ListTile(
  //         title: Text(foods[index]),
  //         subtitle: Text(_getDates()[index].toString() + " days")
  //       );
  //     },
  //     childCount: foods.length
  //   );
  // }

  int _getDays(UserItem item) { 
    DateTime expTimestamp = new DateTime.fromMicrosecondsSinceEpoch(item.expTimestamp.microsecondsSinceEpoch);
    DateTime currTimestamp = new DateTime.now();
    return expTimestamp.difference(currTimestamp).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final UserItemsApi _userItemsApi = UserItemsApi(user.uid);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserItemsNotifier(_userItemsApi)
        )
      ],
      child: Consumer(
        builder: (BuildContext context, UserItemsNotifier userItems, _) {
          return Scaffold(
            body: StreamBuilder(
              stream: userItems.streamUserItems(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  List<UserItem> _foods = snapshot.data.documents
                    .map((item) => UserItem.fromMap(item.data, item.documentID))
                    .toList();
                  
                  _foods.sort((a, b) {
                    return a.expTimestamp.compareTo(b.expTimestamp);
                  });

                  return CustomScrollView(
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
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return ListTile(
                              title: Text(_foods[index].displayName),
                              subtitle: Text(_getDays(_foods[index]).toString() + " days left")
                            );
                          },
                          childCount: _foods.length
                        )
                      )
                    ]
                  );
                } else {
                  return Center(
                    child: Text("No items found.")
                  );
                }
              }
            )
          );
        }
      )
    );
  }
}