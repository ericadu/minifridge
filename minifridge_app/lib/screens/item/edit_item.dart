import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/shelf_life.dart';
import 'package:minifridge_app/services/amplitude.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/buttons/report_button.dart';
import 'package:minifridge_app/widgets/category_dropdown.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class EditItemPage extends StatefulWidget {
  final BaseItem item;
  final FoodBaseApi api;

  EditItemPage({
    this.item,
    this.api
  });

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _purchasedController = TextEditingController();
  BaseItem _current;
  // bool _isSwitched;

  @override
  void initState() {
    _resetControllers();
    _itemNameController.addListener(_updateName);
    super.initState();
  }

  @override
  void dispose() {  
    _itemNameController.dispose();
    _purchasedController.dispose();
    super.dispose();
  }

  void _resetControllers() {
    _current = widget.item;
    _itemNameController.text = _current.displayName;
    _purchasedController.text = DateFormat.yMMMEd().format(_current.referenceDatetime);
  }

  void _callDatePicker() async {
    DateTime purchased = DateFormat.yMMMEd().parse(_purchasedController.text);

    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: DateFormat.yMMMEd().parse(_purchasedController.text),
      firstDate: purchased.subtract(new Duration(days: 14)),
      lastDate: DateTime.now().add(new Duration(days: 14))
    );

    if (newDate != null && newDate != purchased) {
      setState(() {
        _purchasedController.text = DateFormat.yMMMEd().format(newDate);
        _current.reference = newDate;
      });
    }
  }

  void _save() {
    Provider.of<AnalyticsService>(context, listen: false).logEvent(
      'close_edit', {
        'item': widget.item.id,
        'type': 'save'
      }
    );

    widget.api.updateBaseItem(_current.id, _current.toJson()).then((resp) {
      Navigator.of(context).pop();
    });
  }

  void _close() {
    Provider.of<AnalyticsService>(context, listen: false).logEvent(
      'close_edit', {
        'item': widget.item.id,
        'type': 'cancel'
      }
    );

    Navigator.of(context).pop();
  }

  void _updateName() {
    Provider.of<AnalyticsService>(context, listen: false).logEvent(
      'edit_item', {
        'item': widget.item.id,
        'property': 'name'
      }
    );
    setState(() {
      _current.name = _itemNameController.text;
    });
  }

  void _handleChangeStart(num number) {
    setState(() {
      _current.shelfLife.dayRangeStart = new Duration(days: number);
    });
    Provider.of<AnalyticsService>(context, listen: false).logEvent(
      'edit_item', {
        'item': widget.item.id,
        'property': 'shelf_life_start'
      }
    );
  }

  void _handleChangeEnd(num number) {
    setState(() {
      _current.shelfLife.dayRangeEnd = new Duration(days: number);
    });

    Provider.of<AnalyticsService>(context, listen: false).logEvent(
      'edit_item', {
        'item': widget.item.id,
        'property': 'shelf_life_end'
      }
    );
  }

  Widget _renderPerishable() {
    int initialStart = _current.shelfLife.dayRangeStart != null ? _current.shelfLife.dayRangeStart.inDays : 5;
    int initialEnd = _current.shelfLife.dayRangeEnd != null ? _current.shelfLife.dayRangeEnd.inDays : initialStart + 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            NumberPicker.integer(
              initialValue: initialStart,
              minValue: 0,
              maxValue: 1000,
              onChanged: _handleChangeStart
            ),
            Text('to'),
            NumberPicker.integer(
              initialValue: initialEnd,
              minValue: 0,
              maxValue: 1000,
              onChanged: _handleChangeEnd
            ),
            Text('days')
          ],
        )
        
      ]
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Cancel',
          icon: Icon(Icons.close, color: Colors.white, semanticLabel: 'Cancel'),
          onPressed: _close,
        ),
        shadowColor: Colors.white,
        backgroundColor: AppTheme.themeColor,
        actions: [
          ReportButton(
            color: Colors.white,
            item: widget.item
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white
        ),
        onPressed: _save
      ),
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18),
                      controller: _itemNameController
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: CategoryDropdown(
                      value: _current.category,
                      onChanged: (value) {
                        setState(() {
                          _current.newCategory = value;
                        });

                        Provider.of<AnalyticsService>(context, listen: false).logEvent(
                          'edit_item', {
                            'item': widget.item.id,
                            'property': 'category'
                          }
                        );
                      },
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Reference Date", style: TextStyle(fontSize: 16)),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 180,
                        child: TextField(
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16),
                          controller: _purchasedController,
                          onTap: () => _callDatePicker()
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        child: Text('Perishable', style: TextStyle(fontSize: 16)),
                        padding: EdgeInsets.only(right: 10)
                      ),
                      Container(
                        child: Switch(
                          value: _current.shelfLife.perishable,
                          onChanged: (value) {
                            setState(() {
                              _current.shelfLife.perishable = value;

                              if (value) {
                                _current.shelfLife = ShelfLife(
                                  perishable: value,
                                  dayRangeStart: Duration(days: 5),
                                  dayRangeEnd: Duration(days: 7)
                                );
                              } else {
                                _current.shelfLife = ShelfLife(
                                  perishable: value
                                );
                              }
                            });

                            Provider.of<AnalyticsService>(context, listen: false).logEvent(
                              'edit_item', {
                                'item': widget.item.id,
                                'property': 'shelf_life_perishability'
                              }
                            );
                          }
                        ),
                      )
                    ],
                  ),
                  if (_current.shelfLife.perishable)
                    _renderPerishable()
                ]
              )
            )
          )
        )
      )
    );
  }
}