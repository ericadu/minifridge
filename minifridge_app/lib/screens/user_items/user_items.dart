import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/screens/user_items/home_app_bar.dart';
import 'package:minifridge_app/screens/user_items/user_item_list.dart';
import 'package:minifridge_app/view/user_items_notifier.dart';
import 'package:provider/provider.dart';

class UserItemsPage extends StatelessWidget {
  static const routeName = '/items';

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (BuildContext context, UserItemsNotifier userItems, _) {
        return Scaffold(
          body: StreamBuilder(
            stream: userItems.streamUserItems(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data.documents.length > 0) {
                List<UserItem> _foods = snapshot.data.documents
                  .map((item) => UserItem.fromMap(item.data, item.documentID))
                  .where((item) => !item.eaten)
                  .toList();
                
                _foods.sort((a, b) {
                  return a.expTimestamp.compareTo(b.expTimestamp);
                });

                return CustomScrollView(
                  slivers: <Widget>[
                    HomeAppBar(),
                    UserItemList(foods: _foods)
                  ]
                );
              } else {
                return CustomScrollView(
                  slivers: <Widget>[
                    HomeAppBar(),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 400,
                        child: Center(
                          child: Text("No items found! Send us a photo 🍑")
                        )
                      )
                    )
                  ]
                );
              }
            }
          )
        );
      }
    );
  }
}