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
import 'package:minifridge_app/widgets/confirm_exit_buttons.dart';
import 'package:minifridge_app/widgets/edit_item_header.dart';
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
  TextEditingController _referenceController = TextEditingController();

  @override
  void initState() {
    _resetControllers();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _resetControllers() {
    _nameController.text = widget.item.displayName;
    _dateController.text = DateFormat.yMMMEd().format(widget.item.rangeStartDate());
    _referenceController.text = DateFormat.yMMMEd().format(widget.item.referenceDatetime());
  }

  void _callDatePicker(SingleItemNotifier userItem, BuildContext context, bool reference) async {
    DateTime refDatetime = userItem.item.referenceDatetime();
    DateTime newExp = await showDatePicker(
      context: context,
      initialDate: reference ? userItem.item.referenceDatetime() : userItem.item.rangeStartDate(),
      firstDate: reference ? DateTime.now().subtract(Duration(days:30)) : refDatetime,
      lastDate: refDatetime.add(new Duration(days: 365)),
    );
    
    // add a set date function to single item notifier
    if (newExp != null && newExp != refDatetime) {
      setState(() {
        if (reference) {
          _referenceController.text = DateFormat.yMMMEd().format(newExp);
        } else {
          _dateController.text = DateFormat.yMMMEd().format(newExp);
        }
      });
    }
  }

  String _getMessage(BaseItem item) {
    Freshness freshness = item.getFreshness();
    String message;
    if (item.perishable) {
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
    } else {
      message = "🦄  Forever young.";
    }

    return message;
  }



  Widget _buildEditTile(SingleItemNotifier baseItem) {
    Function onCancel = () {
      setState(() {
        view = true;
        _resetControllers();
      });
    };

    Function onConfirm = () {
      setState(() {
        view = true;
        DateTime newReference = DateFormat.yMMMEd().parse(_referenceController.text);
        DateTime newExpiration = DateFormat.yMMMEd().parse(_dateController.text);
        if (newReference.isBefore(newExpiration)) {
          baseItem.updateItem(
            newName: _nameController.text,
            newDate: _dateController.text,
            newReference: _referenceController.text
          );
          
          analytics.logEvent(
            name: 'edit_item', 
            parameters: {'user': Provider.of<AuthNotifier>(context, listen: false).user.uid,
            'type': 'tile'
          });
        } else {
          _resetControllers();
          showFailUpdateBar();
        }
      });
    };

    Function onNonPerishableConfirm = () {
      setState(() {
        view = true;
        baseItem.updateItem(
          newName: _nameController.text
        );
      });

      analytics.logEvent(
        name: 'edit_item', 
        parameters: {'user': Provider.of<AuthNotifier>(context, listen: false).user.uid,
        'type': 'tile'
      });
    };

    if (baseItem.item.perishable) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditItemHeader(),
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
                  Text("Ready By", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 34),
                  Flexible(
                    child: TextField(
                      controller: _referenceController,
                      onTap: () {
                        _callDatePicker(baseItem, context, true);
                      },
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
                        _callDatePicker(baseItem, context, false);
                      },
                    )
                  ),
                ],
              ),

              SizedBox(height:20),
              ConfirmExitButtons(onConfirm: onConfirm, onCancel: onCancel),
              SizedBox(height: 10)
            ],
          ),
        )
      );
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditItemHeader(),
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
            SizedBox(height:20),
            ConfirmExitButtons(onConfirm: onNonPerishableConfirm, onCancel: onCancel),
            SizedBox(height: 10)
          ]
        )
      )
    );
  }

  void showSuccessBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Report submitted!"),
        backgroundColor: AppTheme.lightSecondaryColor,
      )
    );
  }

  void showFailUpdateBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Update failed: invalid dates."),
        backgroundColor: Colors.red,
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
        if (item.perishable)
          Column(
            children: [
              Divider(color: Colors.grey[300]),
              FreshnessTimeline(item: item),
              SizedBox(height: 10),
            ]
          ),
        Divider(color: Colors.grey[300]),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                iconSize: 32,
                icon: Icon(Icons.edit, color: orange),
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
                icon: Icon(Icons.flag, color: orange),
                onPressed: () {
                  expanded = true;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ReportAlertDialog(itemId: item.id, onSubmit: showSuccessBar);
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
