import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/screens/base_items/home_app_bar.dart';
import 'package:minifridge_app/providers/base_items_notifier.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/widgets/base_item_tile.dart';
import 'package:provider/provider.dart';

class BaseItemsPage extends StatelessWidget {
  static const routeName = '/items';

  SliverList _buildList(List<BaseItem> foods) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          BaseItem item = foods[index];

          return Dismissible(
            background: Container(color: Colors.red),
            key: Key(item.id),
            onDismissed: (direction) {
              // Provider.of<BaseItemsNotifier>(context, listen: false).toggleEaten(item);
              analytics.logEvent(
                name: 'dismiss_item', 
                parameters: {'item': item.displayName, 'daysLeft': item.getDays()});

              Scaffold
                .of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text("${item.displayName} removed"),
                    action: SnackBarAction(
                      label: "Undo",
                      textColor: Colors.yellow,
                      onPressed: () {
                        // Provider.of<BaseItemsNotifier>(context, listen: false).toggleEaten(item);
                      }
                    )
                  )
                );
            },
            child: BaseItemTile(item: item)
          );
        },
        childCount: foods.length
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (BuildContext context, BaseItemsNotifier baseItems, _) {
        return StreamBuilder(
          stream: baseItems.streamItems(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.documents.length > 0) {
              List<BaseItem> _foods = snapshot.data.documents
                .map((item) => BaseItem.fromMap(item.data, item.documentID))
                .where((item) => item.endType == EndType.alive)
                .where((item) => item.quantity > 0)
                .toList();
              
              _foods.sort((a, b) {
                return a.getDays().compareTo(b.getDays());
              });

              return CustomScrollView(
                slivers: <Widget>[
                  HomeAppBar(),
                  _buildList(_foods),
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