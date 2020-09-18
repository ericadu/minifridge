import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/models/shelf_life.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/providers/base_notifier.dart';
import 'package:minifridge_app/providers/manual_entry_notifier.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/category_dropdown.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class ManualEntryPage extends StatefulWidget {
  static const routeName = '/manual';

  @override
  _ManualEntryPageState createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends State<ManualEntryPage> {
  final _itemNameController = TextEditingController();
  final _dateController = TextEditingController();
  BaseItem _current = BaseItem(
    shelfLife: ShelfLife(perishable: false),
    category: 'Uncategorized'
  );

  @override
  void initState() {
    super.initState();
    _current.reference = DateTime.now();
    _dateController.text = DateFormat.yMMMEd().format(_current.referenceDatetime);
    _itemNameController.addListener(_updateName);
  }

  void dispose() {
    _itemNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _handleChangeStart(num number) {
      setState(() {
        _current.shelfLife.dayRangeStart = new Duration(days: number);
      });
  }

  void _updateName() {
    setState(() {
      _current.name = _itemNameController.text;
    });
  }

  void _handleChangeEnd(num number) {
    setState(() {
      _current.shelfLife.dayRangeEnd = new Duration(days: number);
    });
  }

  void _callDatePicker(BuildContext context, ManualEntryNotifier manual) async {
    DateTime today = DateTime.now();
    DateTime newRef = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today.subtract(Duration(days: 30)),
      lastDate: today.add(new Duration(days: 3650)),
    );
    
    if (newRef != null) {
      // manual.setDate(newExp);
      setState(() {
        _dateController.text = DateFormat.yMMMEd().format(newRef);
        _current.reference = newRef;
      });
    }
  }

  Widget _buildLeftButton(VoidCallback onStepCancel, ManualEntryNotifier manual) {
    if (manual.currentStep == 0) {
      return Container(
        child: FlatButton(
          child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          onPressed: () => manual.reset()
        ),
      );
    } 

    return Container(
      child: FlatButton(
        child: Text("Back", style: TextStyle(color: Colors.grey)),
        onPressed: onStepCancel
      ),
    );
  }

  Widget _buildRightButton(VoidCallback callback, ManualEntryNotifier manual) {
    if (manual.currentStep + 1 == manual.stepLength) {
      return Container(
        color: AppTheme.lightTheme.accentColor,
        child: FlatButton(
          child: Text("Submit", style: TextStyle(color: Colors.white)),
          onPressed: () {
            _current.addedByUserId = Provider.of<AuthNotifier>(context, listen: false).user.uid;
            _current.endType = EndType.alive;
            _current.buyTimestamp = Timestamp.fromDate(DateTime.now());

            Provider.of<BaseNotifier>(context, listen:false).addNewItem(_current.toJson()).then((doc) {
              manual.reset();
            });

          }
        )
      );
    }

    return Container(
      color: AppTheme.themeColor,
      child: FlatButton(
        child: Text("Next", style: TextStyle(color: Colors.white)),
        onPressed: callback
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    int initialStart = _current.shelfLife.dayRangeStart != null ? _current.shelfLife.dayRangeStart.inDays : 5;
    int initialEnd = _current.shelfLife.dayRangeEnd != null ? _current.shelfLife.dayRangeEnd.inDays : initialStart + 2;
    return Consumer(
      builder: (BuildContext context, ManualEntryNotifier manual, _) {
        List<Step> steps = [
          Step(
            title: const Text('Item Name'),
            isActive: manual.currentStep >= 0 ? true : false,
            state: manual.currentStep > 0 ? StepState.complete : StepState.editing,
            content: Column(
              children: <Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _itemNameController,
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter some text';
                  //   }
                  //   return null;
                  // },
                )
              ]
            )
          ),
          Step(
            title: const Text('Select Category'),
            isActive: manual.currentStep >= 1 ? true : false,
            state: manual.currentStep > 1 ? StepState.complete : StepState.editing,
            content: Column(
              children: <Widget>[
                CategoryDropdown(
                  value: _current.category,
                  onChanged: (value) {
                    // manual.setCategory(value);
                    _current.category = value;
                  }
                )
              ]
            )
          ),
          Step(
            title: const Text('Set Shelf Life'),
            isActive: false,
            state: StepState.editing,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      child: Text('Perishable'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Reference Date"),
                      Container(
                        width: 150,
                        child: TextFormField(
                          controller: _dateController,
                          onTap: () {
                            _callDatePicker(context, manual);
                          }
                        )
                      )
                    ],
                  ),
                SizedBox(height: 20),
                if (_current.shelfLife.perishable)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
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
                      Text('days'),
                    ],
                  )
                
              ]
            )
          ),
        ];

        manual.setStepLength(steps.length);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.themeColor,
            title: Text('Add Manually', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => manual.reset()
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Stepper(
                  steps: steps,
                  controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _buildLeftButton(onStepCancel, manual),
                        SizedBox(height: 100, width: 20),
                        _buildRightButton(onStepContinue, manual)
                      ]
                    );
                  },
                  currentStep: manual.currentStep,
                  onStepContinue: () => {
                    manual.next(_itemNameController.text)
                  },
                  onStepTapped: (step) => manual.goTo(step),
                  onStepCancel: manual.cancel
                )
            )],
          )
        );
      }
    );
  }
}