import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/providers/single_item_notifier.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/buttons/report_button.dart';
import 'package:minifridge_app/widgets/category_dropdown.dart';
import 'package:minifridge_app/widgets/freshness/meter.dart';
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
    // _isSwitched = _current.shelfLife.perishable;
    _purchasedController.text = DateFormat.yMMMEd().format(_current.buyDatetime);

    // if (widget.item.shelfLife.perishable && widget.item.isValidFreshness()) {
    //   _dateController.text = DateFormat.yMMMEd().format(widget.item.rangeStartDate);

    //   if (widget.item.hasRange) {
    //     _endDateController.text = DateFormat.yMMMEd().format(widget.item.rangeEndDate);
    //   }
    // }
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

  void _updateName() {
    setState(() {
      _current.name = _itemNameController.text;
    });
  }

  void _handleChangeStart(num number) {
    setState(() {
      _current.shelfLife.dayRangeStart = new Duration(days: number);
    });
  }

  void _handleChangeEnd(num number) {
    setState(() {
      _current.shelfLife.dayRangeEnd = new Duration(days: number);
    });
  }

  Widget _renderPerishable() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            NumberPicker.integer(
              initialValue: _current.shelfLife.dayRangeStart.inDays,
              minValue: 0,
              maxValue: 1000,
              onChanged: _handleChangeStart
            ),
            Text('to'),
            NumberPicker.integer(
              initialValue: _current.shelfLife.dayRangeEnd != null ? _current.shelfLife.dayRangeEnd.inDays : _current.shelfLife.dayRangeStart.inDays,
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
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
        onPressed: () => {
          // Navigator.of(context).pop()
          print(_current.toJson())
        }
      ),
      body: Container(
        color: Colors.white,
        child: ChangeNotifierProvider(
          create: (_) => SingleItemNotifier(widget.api, widget.item),
          child: Consumer(
            builder: (BuildContext context, SingleItemNotifier edit, _) {
              return Form(
                key: _formKey,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            style: TextStyle(fontSize: 20),
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
                            },
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("Purchased on", style: TextStyle(fontSize: 18)),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 180,
                              child: TextField(
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 18),
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
                              child: Text('Perishable', style: TextStyle(fontSize: 18)),
                              padding: EdgeInsets.only(right: 10)
                            ),
                            Container(
                              child: Switch(
                                value: _current.shelfLife.perishable,
                                onChanged: (value) {
                                  setState(() {
                                    _current.shelfLife.perishable = value;
                                  });
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
              );
            }
          )
        )
      )
    );
  }
}