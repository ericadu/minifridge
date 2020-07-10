import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/providers/single_item_notifier.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class BaseItemTile extends StatelessWidget {

  void _callDatePicker(SingleItemNotifier userItem, BuildContext context) async {
    DateTime refDatetime = userItem.item.referenceDatetime();
    DateTime newExp = await showDatePicker(
      context: context,
      initialDate: refDatetime,
      firstDate: refDatetime.subtract(Duration(days: 5)),
      lastDate: refDatetime.add(new Duration(days: 365)),
    );
    
    if (newExp != null && newExp != refDatetime) {
      userItem.updateRef(Timestamp.fromDate(newExp));
    }
  }

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
        String day = item.getDays() == 1 ? "day" : "days";
        message = "⏳ ${item.getDays()} ${day} left";
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

    final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);

    return Consumer(
      builder: (BuildContext context, SingleItemNotifier baseItem, _) {
        BaseItem item = baseItem.item;
        Freshness freshness = item.getFreshness();

        return Dismissible(
          background: Container(color: Colors.red),
          key: Key(item.id),
          onDismissed: (direction) {
            // Provider.of<BaseItemsNotifier>(context, listen: false).toggleEaten(item);
            analytics.logEvent(
              name: 'dismiss_item', 
              parameters: {'item': item.displayName, 'daysLeft': item.getDays()});

            Scaffold
              .of(context)
              .showSnackBar(
                SnackBar(
                  content: Text("${item.displayName} removed"),
                  action: SnackBarAction(
                    label: "Undo",
                    textColor: Colors.yellow,
                    onPressed: () {
                      // Provider.of<BaseItemsNotifier>(context, listen: false).toggleEaten(item);
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
                      padding: const EdgeInsets.only(left: 30),
                      child: TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineX: 0.3,
                        topLineStyle: activeLine,
                        indicatorStyle: freshness.index > 0 ? activeIndicator : inactiveIndicator,
                        bottomLineStyle: freshness.index > 1 ? activeLine : inactiveLine,
                        leftChild: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Container(
                            child: RaisedButton(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                DateFormat.MEd().format(item.referenceDatetime())
                              ),
                              onPressed: () => _callDatePicker(baseItem, context)
                            )
                          )
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
                      padding: const EdgeInsets.only(left: 30),
                      child:TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineX: 0.3,
                        topLineStyle: freshness.index > 2 ? activeLine : inactiveLine,
                        indicatorStyle: freshness.index > 3 ? activeIndicator : inactiveIndicator,
                        bottomLineStyle: freshness.index > 4 ? activeLine : inactiveLine,
                        leftChild: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            child: Text(DateFormat.MEd().format(item.rangeStartDate()))
                          ),
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
                      padding: const EdgeInsets.only(left: 30),
                      child:TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineX: 0.3,
                        topLineStyle: freshness.index > 5 ? activeLine : inactiveLine,
                        indicatorStyle: freshness.index > 6 ? activeIndicator : inactiveIndicator,
                        bottomLineStyle: freshness.index > 7 ? activeLine : inactiveLine,
                        leftChild: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            child: Text(DateFormat.MEd().format(item.rangeEndDate()))
                          ),
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
          )
        );
      }
    );
  }
}
