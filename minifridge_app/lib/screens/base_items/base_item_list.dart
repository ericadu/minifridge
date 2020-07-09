import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/util.dart';
import 'package:minifridge_app/providers/base_items_notifier.dart';
import 'package:minifridge_app/widgets/base_item_tile.dart';
import 'package:provider/provider.dart';

class UserItemList extends StatelessWidget {
  final foods;
  
  const UserItemList({Key key, this.foods}) : super(key: key);
  
  bool _validItem(BaseItem item) {
    return Util.getDays(item) > -1 && item.quantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    List<BaseItem> currentItems = foods.where((item) => _validItem(item)).toList();
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          BaseItem item = currentItems[index];

          return Dismissible(
            background: Container(color: Colors.red),
            key: Key(item.id),
            onDismissed: (direction) {
              Provider.of<BaseItemsNotifier>(context, listen: false).toggleEaten(item);
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
                        Provider.of<BaseItemsNotifier>(context, listen: false).toggleEaten(item);
                      }
                    )
                  )
                );
            },
            child: BaseItemTile(item: item)
          );
        },
        childCount: currentItems.length
      )
    );
  }
}