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

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ListTile(
            title: Text(foods[index].displayName),
            subtitle: Text(_getDays(foods[index]).toString() + " days left")
          );
        },
        childCount: foods.length
      )
    );
  }
}