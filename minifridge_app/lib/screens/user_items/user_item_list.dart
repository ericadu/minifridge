import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/view/user_items_notifier.dart';
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
          DateTime expTimestamp = new DateTime.fromMicrosecondsSinceEpoch(item.expTimestamp.microsecondsSinceEpoch);
          var newDt = DateFormat.MEd().format(expTimestamp);
          final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);

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
                child: Theme(data: newTheme, child: 
                  ExpansionTile(
                    title: Text(item.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(_getMessage(item)),
                    ),
                    children: <Widget>[
                      Divider(color: Colors.grey[300]),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Editing item")
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Fresh Until'),
                            Text(newDt)
                          ]
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Quantity'),
                            // Row(
                            //   children: <Widget>[
                            //     _quantity > 0 ? IconButton(
                            //       icon: Icon(Icons.remove_circle),
                            //       color: Colors.red,
                            //       onPressed: () => decrement()
                            //     ) : IconButton(
                            //       icon: Icon(Icons.remove_circle),
                            //       color: Colors.grey,
                            //       onPressed: () => {}
                            //     ),
                            //     Text(_quantity.toString()),
                            //     IconButton(
                            //       icon: Icon(Icons.add_circle),
                            //       color: Colors.green,
                            //       onPressed: () => increment()
                            //     )
                            //   ]
                            // )
                          ]
                        ),
                      ),
                    ]
                  ),
                )
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