import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/util.dart';
import 'package:minifridge_app/providers/user_items_notifier.dart';
import 'package:minifridge_app/widgets/user_item_tile.dart';
import 'package:provider/provider.dart';

class UserItemList extends StatelessWidget {
  final foods;
  
  const UserItemList({Key key, this.foods}) : super(key: key);
  
  bool _validItem(UserItem item) {
    return Util.getDays(item) > -1 && item.quantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    List<UserItem> currentItems = foods.where((item) => _validItem(item)).toList();
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          UserItem item = currentItems[index];

          return Dismissible(
            background: Container(color: Colors.red),
            key: Key(item.displayName),
            onDismissed: (direction) {
              Provider.of<UserItemsNotifier>(context, listen: false).toggleEaten(item);
              analytics.logEvent(
                name: 'dismiss_item', 
                parameters: {'item': item.displayName, 'daysLeft': Util.getDays(item)});

              Scaffold
                .of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text("${item.displayName} removed"),
                    action: SnackBarAction(
                      label: "Undo",
                      textColor: Colors.yellow,
                      onPressed: () {
                        Provider.of<UserItemsNotifier>(context, listen: false).toggleEaten(item);
                      }
                    )
                  )
                );
            },
            child: UserItemTile(item: item)
          );
        },
        childCount: currentItems.length
      )
    );
  }
}