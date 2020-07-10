import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/user_items_api.dart';
import 'package:minifridge_app/providers/single_item_notifier.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/widgets/freshness_meter.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class BaseItemTile extends StatefulWidget {
  final BaseItem item;

  const BaseItemTile({Key key, this.item}) : super(key: key);

  @override
  _BaseItemTileState createState() => _BaseItemTileState();
}

class _BaseItemTileState extends State<BaseItemTile> {

  String _getMessage(BaseItem item) {
    Freshness freshness = item.getFreshness();
    String message;
    switch(freshness) {
      case Freshness.in_range_start:
      case Freshness.in_range_min:
      case Freshness.in_range_max:
      case Freshness.in_range_end:
        message = "⏰ Eat me ASAP";
        break;
      case Freshness.ready:
      case Freshness.fresh_min:
      case Freshness.fresh_max:
        if (item.getDays() < 9) {
           message = "⏳ " + item.getDays().toString() + " days left";
        } else {
          message = "🌱 Fresh AF";
        }
        break;
      case Freshness.past:
        message = "👀 Caution";
        break;
      default:
        message = "⏳ " + item.getDays().toString() + " days left";
    }

    return message;
  }

  @override
  Widget build(BuildContext context) {
    // final FirebaseUser user = Provider.of<AuthNotifier>(context, listen: false).user;
    // final UserItemsApi _userItemsApi = UserItemsApi(user.uid);
    DateTime now = DateTime.now();

    const Color inactiveGrey = const Color(0xffd6d6d6);
    const Color activeColor = Colors.teal;

    IndicatorStyle activeIndicator = const IndicatorStyle(
      width: 18,
      indicatorY: 0.5,
      color: activeColor
    );

    LineStyle activeLine = const LineStyle(
      color: activeColor,
      width: 6,
    );

    IndicatorStyle inactiveIndicator = const IndicatorStyle(
      width: 16,
      indicatorY: 0.5,
      color: inactiveGrey
    );

    LineStyle inactiveLine = const LineStyle(
      color: inactiveGrey,
    );

    BaseItem item = widget.item;
    final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);

    Freshness freshness = item.getFreshness();

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 3, bottom: 10),
        child: Theme(data: newTheme, child:
          ExpansionTile(
            title: Text(item.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold
              )
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(_getMessage(item))
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
                padding: const EdgeInsets.only(left: 40),
                child: TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineX: 0.28,
                  topLineStyle: activeLine,
                  indicatorStyle: freshness.index > 0 ? activeIndicator : inactiveIndicator,
                  bottomLineStyle: freshness.index > 1 ? activeLine : inactiveLine,
                  leftChild: Container(
                    child: Text(DateFormat.MEd().format(item.buyDatetime()))
                  ),
                  rightChild: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 18, left: 25),
                      child: Text("💯  Ready to eat", style: TextStyle(fontSize: 17))
                    )
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child:TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineX: 0.28,
                  topLineStyle: freshness.index > 2 ? activeLine : inactiveLine,
                  indicatorStyle: freshness.index > 3 ? activeIndicator : inactiveIndicator,
                  bottomLineStyle: freshness.index > 4 ? activeLine : inactiveLine,
                  leftChild: Container(
                    child: Text(DateFormat.MEd().format(item.rangeStartDate()))
                  ),
                  rightChild: Container(
                    constraints: const BoxConstraints(
                      minHeight: 70,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("⏰  Eat ASAP", style: TextStyle(fontSize: 17)),
                          Padding(
                            padding: EdgeInsets.only(top:5),
                            child: Text("Expiration Zone")
                          )
                        ],
                      )
                    )
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child:TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineX: 0.28,
                  topLineStyle: freshness.index > 5 ? activeLine : inactiveLine,
                  indicatorStyle: freshness.index > 6 ? activeIndicator : inactiveIndicator,
                  bottomLineStyle: freshness.index > 7 ? activeLine : inactiveLine,
                  leftChild: Container(
                    child: Text(DateFormat.MEd().format(item.rangeEndDate()))
                  ),
                  rightChild: Container(
                    constraints: const BoxConstraints(
                      minHeight: 70,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 25),
                      child: Text("👀  Caution", style: TextStyle(fontSize: 17))
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}
    // return ChangeNotifierProvider(
    //   create: (_) => SingleItemNotifier(_userItemsApi, item),
    //   child: Consumer(
    //     builder: (BuildContext context, SingleItemNotifier userItem, _) {

    //       DateTime expTimestamp = DateTime.now();
    //       var newDt = DateFormat.MEd().format(expTimestamp);
    //       final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);
    //       return Card(
    //         child: Padding(
    //           padding: const EdgeInsets.only(top: 3, bottom: 10),
    //           child: Theme(data: newTheme, child: 
    //             ExpansionTile(
    //               title: Text(item.displayName,
    //                 style: const TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               subtitle: Padding(
    //                 padding: const EdgeInsets.only(top: 3),
    //                 child: Text(_getMessage(userItem.item)),
    //               ),
    //               onExpansionChanged: (bool expanded) {
    //                 analytics.logEvent(name: 'expand_item', parameters: {
    //                   'item': item.displayName,
    //                   'daysLeft': item.getDays(),
    //                   'action': expanded ? 'expand' : 'collapse'
    //                 });
    //               },
    //               children: <Widget>[
    //                 Divider(color: Colors.grey[300]),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: <Widget>[
    //                       Text('Fresh Until'),
    //                       RaisedButton(
    //                         child: Text(newDt),
    //                         onPressed: () => _callDatePicker(userItem)
    //                       )
    //                     ]
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 10),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: <Widget>[
    //                       Text('Quantity'),
    //                       Row(
    //                         children: <Widget>[
    //                           userItem.quantity > 0 ? IconButton(
    //                             icon: Icon(Icons.remove_circle),
    //                             color: Colors.red,
    //                             onPressed: () => userItem.decrement()
    //                           ) : IconButton(
    //                             icon: Icon(Icons.remove_circle),
    //                             color: Colors.grey,
    //                             onPressed: () => {}
    //                           ),
    //                           Text(userItem.quantity.toString()),
    //                           IconButton(
    //                             icon: Icon(Icons.add_circle),
    //                             color: Colors.green,
    //                             onPressed: () => userItem.increment()
    //                           )
    //                         ]
    //                       )
    //                     ]
    //                   ),
    //                 ),
    //               ]
    //             ),
    //           )
    //         )
    //       );
    //     }
    //   )
    // );
