import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/services/user_items_api.dart';
import 'package:minifridge_app/util.dart';
import 'package:minifridge_app/view/single_item_notifier.dart';
import 'package:minifridge_app/view/user_items_notifier.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class UserItemTile extends StatefulWidget {
  final UserItem item;

  const UserItemTile({Key key, this.item}) : super(key: key);

  @override
  _UserItemTileState createState() => _UserItemTileState();
}

class _UserItemTileState extends State<UserItemTile> {
  
  
  String _getMessage(UserItem item) {
    int daysLeft = Util.getDays(item);
    if (daysLeft == 0) {
      return "⏰ Eat me today";
    } else if (daysLeft == 1) {
      return "⏳ Eat me tomorrow ";
    } else {
      return daysLeft.toString() + " days left";
    }
  }

  void _callDatePicker(SingleItemNotifier userItem) async {
    DateTime expTimestamp = new DateTime.fromMicrosecondsSinceEpoch(userItem.expTimestamp.microsecondsSinceEpoch);
    DateTime newExp = await showDatePicker(
      context: context,
      initialDate: expTimestamp,
      firstDate: DateTime.now(),
      lastDate: expTimestamp.add(new Duration(days: 365)),
    );
    
    if (newExp != null && newExp != expTimestamp) {
      userItem.updateExp(Timestamp.fromDate(newExp));
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<UserNotifier>(context, listen: false).user;
    final UserItemsApi _userItemsApi = UserItemsApi(user.uid);

    UserItem item = widget.item;

    return ChangeNotifierProvider(
      create: (_) => SingleItemNotifier(_userItemsApi, item),
      child: Consumer(
        builder: (BuildContext context, SingleItemNotifier userItem, _) {

          DateTime expTimestamp = new DateTime.fromMicrosecondsSinceEpoch(userItem.expTimestamp.microsecondsSinceEpoch);
          var newDt = DateFormat.MEd().format(expTimestamp);
          final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);
          return Card(
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
                    child: Text(_getMessage(userItem.item)),
                  ),
                  children: <Widget>[
                    Divider(color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Fresh Until'),
                          RaisedButton(
                            child: Text(newDt),
                            onPressed: () => _callDatePicker(userItem)
                          )
                        ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Quantity'),
                          Row(
                            children: <Widget>[
                              userItem.quantity > 0 ? IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.red,
                                onPressed: () => userItem.decrement()
                              ) : IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.grey,
                                onPressed: () => {}
                              ),
                              Text(userItem.quantity.toString()),
                              IconButton(
                                icon: Icon(Icons.add_circle),
                                color: Colors.green,
                                onPressed: () => userItem.increment()
                              )
                            ]
                          )
                        ]
                      ),
                    ),
                  ]
                ),
              )
            )
          );
        }
      )
    );
  }
}