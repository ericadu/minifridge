import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/screens/base_items/home_app_bar.dart';
import 'package:minifridge_app/screens/base_items/base_item_list.dart';
import 'package:minifridge_app/providers/base_items_notifier.dart';
import 'package:provider/provider.dart';

class BaseItemsPage extends StatelessWidget {
  static const routeName = '/items';

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (BuildContext context, BaseItemsNotifier userItems, _) {
        return StreamBuilder(
          stream: userItems.streamUserItems(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.documents.length > 0) {
              List<BaseItem> _foods = snapshot.data.documents
                .map((item) => BaseItem.fromMap(item.data, item.documentID))
                .where((item) => item.endType == EndType.alive)
                .toList();
              
              // _foods.sort((a, b) {
              //   return a.expTimestamp.compareTo(b.expTimestamp);
              // });

              return CustomScrollView(
                slivers: <Widget>[
                  HomeAppBar(),
                  BaseItemList(foods: _foods),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 50),
                  ),
                  
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
        );
      }
    );
  }
}