import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/screens/base_items/report_alert_dialog.dart';
import 'package:minifridge_app/screens/base_items/tile/edit_item_tile.dart';
import 'package:minifridge_app/screens/base_items/tile/tile_toolbar.dart';
import 'package:minifridge_app/screens/base_items/tile/view_item_tile.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/theme.dart';

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

  void setViewMode() {
    setState(() {
      view = true;
    });
  }

  void showSuccessBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Report submitted!"),
        backgroundColor: AppTheme.lightSecondaryColor,
      )
    );
  }

  void onEdit() {
    setState(() {
      view = false;
      expanded = true;
    });
  }

  void onFlag() {
    setState(() {
      expanded = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportAlertDialog(itemId: widget.item.id, onSubmit: showSuccessBar);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);
    TileToolbar toolbar = TileToolbar(onEdit: onEdit, onFlag: onFlag);

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 3, bottom: 10),
        child: Theme(
          data: newTheme,
          child: view ? 
            ViewItemTile(item: widget.item, toolbar: toolbar, expanded: expanded) : 
            EditItemTile(item: widget.item, setViewMode: setViewMode)
        )
      )
    );
  }
}
