import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/user_items_api.dart';
import 'package:minifridge_app/providers/single_item_notifier.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:provider/provider.dart';

class BaseItemTile extends StatefulWidget {
  final BaseItem item;

  const BaseItemTile({Key key, this.item}) : super(key: key);

  @override
  _BaseItemTileState createState() => _BaseItemTileState();
}

class _BaseItemTileState extends State<BaseItemTile> {
  
  
  String _getMessage(BaseItem item) {
    int daysLeft = item.getDays();
    if (daysLeft == 0) {
      return "⏰ Eat me today";
    } else if (daysLeft == 1) {
      return "⏳ Eat me tomorrow ";
    } else {
      return daysLeft.toString() + " days left";
    }
  }

  void _callDatePicker(SingleItemNotifier userItem) async {
    // DateTime expTimestamp = new DateTime.fromMicrosecondsSinceEpoch(userItem.expTimestamp.microsecondsSinceEpoch);
    DateTime expTimestamp = new DateTime.now();
    await showDatePicker(
      context: context,
      initialDate: expTimestamp,
      firstDate: DateTime.now(),
      lastDate: expTimestamp.add(new Duration(days: 365)),
    );
    
    // if (newExp != null && newExp != expTimestamp) {
    //   userItem.updateExp(Timestamp.fromDate(newExp));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<AuthNotifier>(context, listen: false).user;
    final UserItemsApi _userItemsApi = UserItemsApi(user.uid);

    BaseItem item = widget.item;

    return ChangeNotifierProvider(
      create: (_) => SingleItemNotifier(_userItemsApi, item),
      child: Consumer(
        builder: (BuildContext context, SingleItemNotifier userItem, _) {

          DateTime expTimestamp = DateTime.now();
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
                  onExpansionChanged: (bool expanded) {
                    analytics.logEvent(name: 'expand_item', parameters: {
                      'item': item.displayName,
                      'daysLeft': item.getDays(),
                      'action': expanded ? 'expand' : 'collapse'
                    });
                  },
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