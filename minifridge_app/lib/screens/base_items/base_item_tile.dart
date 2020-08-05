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

class DatePickerMetadata {
  DateTime initialDate;
  DateTime firstDate;
  Function onUpdate;

  DatePickerMetadata({this.initialDate, this.firstDate, this.onUpdate});
}

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
  TextEditingController _endDateController = TextEditingController();
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
    _endDateController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _resetControllers() {
    _nameController.text = widget.item.displayName;

    if (widget.item.shelfLife.perishable) {
      _dateController.text = DateFormat.yMMMEd().format(widget.item.rangeStartDate());
      _referenceController.text = DateFormat.yMMMEd().format(widget.item.referenceDatetime());

      if (widget.item.hasRange()) {
        _endDateController.text = DateFormat.yMMMEd().format(widget.item.rangeEndDate());
      }
    }

  }

  void _callDatePicker(SingleItemNotifier userItem, BuildContext context, DatePickerMetadata metadata) async {
    DateTime refDatetime = userItem.item.referenceDatetime();

    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: metadata.initialDate,
      firstDate: metadata.firstDate,
      lastDate: refDatetime.add(new Duration(days: 365))
    );
    
    // add a set date function to single item notifier
    if (newDate != null && newDate != refDatetime) {
      metadata.onUpdate(newDate);
    }
  }

  String _getMessage(BaseItem item) {
    String message;
    if (item.shelfLife.perishable) {
      Freshness freshness = item.getFreshness();
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

  Widget _buildFormRow(String label, TextEditingController controller, Function onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
        // SizedBox(width: 70),
        Container(
          width: 200,
          child: TextField(
            style: TextStyle(fontSize: 15),
            controller: controller,
            onTap: onTap
          )
        ),
      ],
    );
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

    if (baseItem.item.shelfLife.perishable) {
      DatePickerMetadata referenceDateMetadata = DatePickerMetadata(
        firstDate: DateTime.now().subtract(Duration(days:30)),
        initialDate: baseItem.item.referenceDatetime(),
        onUpdate: (DateTime newDate) {
          setState(() {
            _referenceController.text = DateFormat.yMMMEd().format(newDate);
          });
        }
      );

      DatePickerMetadata rangeStartMetadata = DatePickerMetadata(
        firstDate: baseItem.item.referenceDatetime(),
        initialDate: baseItem.item.rangeStartDate(),
        onUpdate: (DateTime newDate) {
          setState(() {
            _dateController.text = DateFormat.yMMMEd().format(newDate);
          });
        }
      );

      return Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditItemHeader(),
              _buildFormRow("name", _nameController, (){}),
              _buildFormRow("ready by", _referenceController, () => _callDatePicker(baseItem, context, referenceDateMetadata)),
              _buildFormRow(baseItem.item.hasRange() ? "wilty by" : "expired by", _dateController, () => _callDatePicker(baseItem, context, rangeStartMetadata)),
              if (baseItem.item.hasRange())
                _buildFormRow("expired by", _endDateController, () => _callDatePicker(baseItem, context, DatePickerMetadata(
                  firstDate: baseItem.item.referenceDatetime(),
                  initialDate: baseItem.item.rangeEndDate(),
                  onUpdate: (DateTime newDate) {
                    setState(() {
                      _endDateController.text = DateFormat.yMMMEd().format(newDate);
                    });
                  }
                ))),
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
          'action': expanded ? 'expand' : 'collapse',
          'user': Provider.of<AuthNotifier>(context, listen:false).user.uid
        });
      },
      children: <Widget>[
        if (item.shelfLife.perishable)
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
