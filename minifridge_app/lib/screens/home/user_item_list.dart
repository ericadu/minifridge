import 'package:flutter/cupertino.dart';
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

  Future<bool> promptUser(DismissDirection direction) async {
    
  }

  @override
  Widget build(BuildContext context) {
    List<UserItem> currentItems = foods.where((item) => _getDays(item) > -1).toList();
    print(currentItems.length);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          UserItem item = currentItems[index];
          return Dismissible(
            background: Container(color: Colors.red),
            key: Key(item.displayName),
            confirmDismiss: (direction) {
              return showCupertinoDialog<bool>(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  content: Text("Are you sure you want to remove ${item.displayName}?"),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      }
                    ),
                    CupertinoDialogAction(
                      child: Text("Cancel"),
                      onPressed: () {
                        return Navigator.of(context).pop(false);
                      }
                    )
                  ]
                )
              );
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                print("DISMISSED");

                Scaffold
                  .of(context)
                  .showSnackBar(
                    SnackBar(
                      content: Text("${item.displayName} removed"),
                      action: SnackBarAction(
                        label: "Undo",
                        textColor: Colors.yellow,
                        onPressed: () {
                          print("UNDO");
                        }
                      )
                    )
                  );
              }
            },
            child: ListTile(
              title: Text(item.displayName),
              subtitle: Text(_getMessage(item))
            ),
          );
        },
        childCount: currentItems.length
      )
    );
  }
}