import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';

class UserItemList extends StatelessWidget {
  final foods;
  
  const UserItemList({Key key, this.foods}) : super(key: key);

  int _getDays(UserItem item) { 
    DateTime expTimestamp = new DateTime.fromMicrosecondsSinceEpoch(item.expTimestamp.microsecondsSinceEpoch);
    DateTime currTimestamp = new DateTime.now();
    return expTimestamp.difference(currTimestamp).inDays;
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
    List<UserItem> currentItems = foods.where((item) => _getDays(item) > -1).toList();
    print(currentItems.length);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ListTile(
            title: Text(currentItems[index].displayName),
            subtitle: Text(_getMessage(currentItems[index]))
          );
        },
        childCount: currentItems.length
      )
    );
  }
}