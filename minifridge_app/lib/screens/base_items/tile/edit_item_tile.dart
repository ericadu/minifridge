import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/providers/base_notifier.dart';
import 'package:minifridge_app/providers/single_item_notifier.dart';
import 'package:minifridge_app/providers/tile_view_notifier.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/widgets/category_dropdown.dart';
import 'package:minifridge_app/widgets/confirm_exit_buttons.dart';
import 'package:minifridge_app/widgets/edit_item_header.dart';
import 'package:provider/provider.dart';

class DatePickerMetadata {
  DateTime initialDate;
  DateTime firstDate;
  Function onUpdate;

  DatePickerMetadata({this.initialDate, this.firstDate, this.onUpdate});
}

class EditItemTile extends StatefulWidget {
  final BaseItem item;

  EditItemTile({
    this.item
  });

  @override
  _EditItemTileState createState() => _EditItemTileState();
}

class _EditItemTileState extends State<EditItemTile> {
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  String _category;

  @override
  void initState() {
    _resetControllers();
    super.initState();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _dateController.dispose();
    _endDateController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _resetControllers() {
    _itemNameController.text = widget.item.displayName;
    _referenceController.text = DateFormat.yMMMEd().format(widget.item.referenceDatetime());

    if (widget.item.shelfLife.perishable && widget.item.isValidFreshness()) {
      _dateController.text = DateFormat.yMMMEd().format(widget.item.rangeStartDate());

      if (widget.item.hasRange()) {
        _endDateController.text = DateFormat.yMMMEd().format(widget.item.rangeEndDate());
      }
    }

    _category = widget.item.category;
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

  void _callDatePicker(SingleItemNotifier userItem, BuildContext context, DatePickerMetadata metadata) async {
    DateTime refDatetime = userItem.item.referenceDatetime();

    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: metadata.initialDate,
      firstDate: metadata.firstDate,
      lastDate: DateTime.now().add(new Duration(days: 3650))
    );
    
    // add a set date function to single item notifier
    if (newDate != null && newDate != refDatetime) {
      metadata.onUpdate(newDate);
    }
  }

  void showFailUpdateBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Update failed: invalid dates."),
        backgroundColor: Colors.red,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    FoodBaseApi api = Provider.of<BaseNotifier>(context, listen: false).api;
    return ChangeNotifierProvider(
      create: (_) => SingleItemNotifier(api, widget.item),
      child: Consumer2(
        builder: (BuildContext context, SingleItemNotifier single, TileViewNotifier tileView, _) {
          DatePickerMetadata referenceDateMetadata = DatePickerMetadata(
            firstDate: DateTime.now().subtract(Duration(days:30)),
            initialDate: single.item.referenceDatetime(),
            onUpdate: (DateTime newDate) {
              setState(() {
                _referenceController.text = DateFormat.yMMMEd().format(newDate);
              });
            }
          );

          Function onCancel = () {
            tileView.onView();
            _resetControllers();
          };

          Function onNonPerishableConfirm = () {
            tileView.onView();

            setState(() {
              single.updateItem(
                newName: _itemNameController.text,
                newCategory: _category,
                newReference: _referenceController.text
              );
            });
          };

          Function onConfirm = () {
            tileView.onView();

            setState(() {
              DateTime newReference = DateFormat.yMMMEd().parse(_referenceController.text);
              DateTime newExpiration = DateFormat.yMMMEd().parse(_dateController.text);
              if (newReference.isBefore(newExpiration)) {
                single.updateItem(
                  newName: _itemNameController.text,
                  newCategory: _category,
                  newDate: _dateController.text,
                  newReference: _referenceController.text,
                  newEndDate: _endDateController.text
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

          if (single.item.shelfLife.perishable) {
            DatePickerMetadata rangeStartMetadata = DatePickerMetadata(
              firstDate: single.item.referenceDatetime(),
              initialDate: widget.item.isValidFreshness() ? single.item.rangeStartDate() : single.item.referenceDatetime(),
              onUpdate: (DateTime newDate) {
                setState(() {
                  _dateController.text = DateFormat.yMMMEd().format(newDate);
                });
              }
            );   

            return Form(
              key: _formKey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditItemHeader(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("name".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                            width: 200,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontSize: 15),
                              controller: _itemNameController,
                            )
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("category".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                          // SizedBox(width: 70),
                          Container(
                            width: 200,
                            child: CategoryDropdown(
                              value: _category,
                              onChanged: (value) {
                                setState(() {
                                  _category = value;
                                });
                              },
                            )
                          ),
                        ],
                      ),
                      _buildFormRow("ready to eat", _referenceController, () => _callDatePicker(single, context, referenceDateMetadata)),
                      _buildFormRow(single.item.hasRange() ? "warn me by" : "caution by", _dateController, () => _callDatePicker(single, context, rangeStartMetadata)),
                      if (single.item.hasRange())
                        _buildFormRow("caution by", _endDateController, () => _callDatePicker(single, context, DatePickerMetadata(
                          firstDate: single.item.referenceDatetime(),
                          initialDate: single.item.rangeEndDate(),
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
              )
            ); 
          }

          return Form(
            key: _formKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditItemHeader(),
                    _buildFormRow("name", _itemNameController, (){}),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("category".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                          // SizedBox(width: 70),
                          Container(
                            width: 200,
                            child: CategoryDropdown(
                              value: _category,
                              onChanged: (value) {
                                setState(() {
                                  _category = value;
                                });
                              },
                            )
                          ),
                        ],
                      ),
                    _buildFormRow("purchased", _referenceController, () => _callDatePicker(single, context, referenceDateMetadata)),
                    SizedBox(height:20),
                    ConfirmExitButtons(onConfirm: onNonPerishableConfirm, onCancel: onCancel),
                    SizedBox(height: 10)
                  ]
                )
              )
            )
          );
        }
      )
    );
  }
}