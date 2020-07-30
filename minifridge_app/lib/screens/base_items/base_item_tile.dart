import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/screens/base_items/freshness_timeline.dart';
import 'package:minifridge_app/screens/base_items/report_alert_dialog.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/providers/single_item_notifier.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/theme.dart';
import 'package:provider/provider.dart';

class BaseItemTile extends StatefulWidget {
  final BaseItem item;
  final FoodBaseApi api;

  const BaseItemTile({Key key, this.item, this.api}) : super(key: key);

  @override
  _BaseItemTileState createState() => _BaseItemTileState();
}

class _BaseItemTileState extends State<BaseItemTile> {
  bool view = true;
  bool expanded = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    _resetControllers();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _resetControllers() {
    _nameController.text = widget.item.displayName;
    _dateController.text = DateFormat.yMMMEd().format(widget.item.rangeStartDate());
  }

  void _callDatePicker(SingleItemNotifier userItem, BuildContext context) async {
    DateTime refDatetime = userItem.item.referenceDatetime();
    DateTime newExp = await showDatePicker(
      context: context,
      initialDate: userItem.item.rangeStartDate(),
      firstDate: DateTime.now().subtract(Duration(days:30)),
      lastDate: refDatetime.add(new Duration(days: 365)),
    );
    
    // add a set date function to single item notifier
    if (newExp != null && newExp != refDatetime) {
      setState(() {
        _dateController.text = DateFormat.yMMMEd().format(newExp);
      });
    }
  }

  String _getMessage(BaseItem item) {
    Freshness freshness = item.getFreshness();
    String message;
    switch(freshness) {
      case Freshness.in_range:
        message = "⏰ Eat me next";
        break;
      case Freshness.ready:      
        if (item.getDays() == 1) {
          message = "⏳  1 day left";
        } else if (item.getDays() > 7) {
          message = "💚​  Fresh AF";
        } else {
          message = "⏳  ${item.getDays()} days left";
        }
        break;
      case Freshness.past:
        message = "😬  Caution";
        break;
      case Freshness.not_ready:
        message = "🐣  Not quite ready";
        break;
      default:
        message = "⏳  " + item.getDays().toString() + " days left";
    }

    return message;
  }

  Widget _buildEditTile(SingleItemNotifier baseItem) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom:20),
              child: Text(
                "Editing",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.lightSecondaryColor)
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 70),
                Flexible(
                  child: TextField(
                    controller: _nameController
                  )
                ),
                
              ],
            ),
            SizedBox(height:15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Expiration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 32),
                Flexible(
                  child: TextField(
                    controller: _dateController,
                    onTap: () {
                      _callDatePicker(baseItem, context);
                    },
                  )
                ),
              ],
            ),
            SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Ink(
                  decoration: ShapeDecoration(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      )
                    )
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        view = true;
                        _resetControllers();
                      });
                    }
                  )
                ),
                Ink(
                  decoration: ShapeDecoration(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      )
                    )
                  ),
                  child: IconButton(
                    icon: Icon(Icons.done, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        view = true;
                        baseItem.updateItem(
                          newName: _nameController.text,
                          newDate: _dateController.text
                        );
                        
                        analytics.logEvent(
                          name: 'edit_item', 
                          parameters: {'user': Provider.of<AuthNotifier>(context, listen: false).user.uid,
                          'type': 'tile'
                        });
                      });
                    }
                  )
                )
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      )
    );
  }

  Widget _buildTile(SingleItemNotifier baseItem) {
    BaseItem item = baseItem.item;

    MaterialColor orange = AppTheme.generateMaterialColor(AppTheme.lightSecondaryColor);

    return ExpansionTile(
      initiallyExpanded: expanded,
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
          'action': expanded ? 'expand' : 'collapse',
          'user': Provider.of<AuthNotifier>(context, listen:false).user.uid
        });
      },
      children: <Widget>[
        Divider(color: Colors.grey[300]),
        FreshnessTimeline(item: item),
        SizedBox(height: 10),
        Divider(color: Colors.grey[300]),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                iconSize: 32,
                icon: Icon(Icons.edit, color: orange[300]),
                onPressed: () {
                  setState(() {
                    view = false;
                    expanded = true;
                  });                  
                }
              )
            ),
            Container(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                iconSize: 32,
                icon: Icon(Icons.flag, color: orange[300]),
                onPressed: () {
                  expanded = true;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ReportAlertDialog();
                    }
                  );               
                }
              )
            )
          ],
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);

    return ChangeNotifierProvider(
      create: (_) => SingleItemNotifier(widget.api, widget.item),
      child: Consumer(
        builder: (BuildContext context, SingleItemNotifier baseItem, _) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 10),
              child: Theme(data: newTheme,
              child: view ? _buildTile(baseItem) : _buildEditTile(baseItem)
              )
            )
          );
        }
      )
    );
  }
}
