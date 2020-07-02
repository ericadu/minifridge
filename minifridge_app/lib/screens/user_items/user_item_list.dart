import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/view/user_items_notifier.dart';
import 'package:minifridge_app/widgets/user_item_bottom_sheet.dart';
import 'package:provider/provider.dart';

class UserItemList extends StatelessWidget {
  final foods;
  
  const UserItemList({Key key, this.foods}) : super(key: key);

  int _getDays(UserItem item) { 
    DateTime expTimestamp = new DateTime.fromMicrosecondsSinceEpoch(item.expTimestamp.microsecondsSinceEpoch);
    DateTime currTimestamp = new DateTime.now();
    return expTimestamp.difference(currTimestamp).inDays;
  }

  bool _validItem(UserItem item) {
    return _getDays(item) > -1 && item.quantity > 0;
  }

  String _getMessage(UserItem item) {
    int daysLeft = _getDays(item);
    if (daysLeft == 0) {
      return "⏰ Eat me today";
    } else if (daysLeft == 1) {
      return "⏳ Eat me tomorrow ";
    } else {
      return daysLeft.toString() + " days left";
    }
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
                parameters: {'item': item.displayName, 'daysLeft': _getDays(item).toString()});

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
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 10),
                child: ListTile(
                  title: Text(item.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(_getMessage(item)),
                  ),
                  trailing: Icon(Icons.more_horiz),
                ),
              )
            )
            // child: InkWell(
            //   onTap: () {
            //     showBottomSheet(
            //       context: context,
            //       builder: (context) => UserItemBottomSheet(item: item)
            //     );

            //     analytics.logEvent(
            //       name: 'click_item', 
            //       parameters: {'item': item.displayName});
            //     },
            //   child: ListTile(
            //     title: Text(item.displayName),
            //     subtitle: Text(_getMessage(item)),
            //   )
            // ),
          );
        },
        childCount: currentItems.length
      )
    );
  }
}