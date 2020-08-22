import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/providers/tile_view_notifier.dart';
import 'package:minifridge_app/screens/base_items/report_alert_dialog.dart';
import 'package:minifridge_app/screens/base_items/tile/edit_item_tile.dart';
import 'package:minifridge_app/screens/base_items/tile/tile_toolbar.dart';
import 'package:minifridge_app/screens/base_items/tile/view_item_tile.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/theme.dart';
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

  void showSuccessBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Report submitted!"),
        backgroundColor: AppTheme.lightSecondaryColor,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);

    return ChangeNotifierProvider(
      create: (_) => TileViewNotifier(),
      child: Consumer(
        builder: (BuildContext context, TileViewNotifier tileView, _) {

          Function onFlag = () {
            tileView.expand();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ReportAlertDialog(itemId: widget.item.id, onSubmit: showSuccessBar);
              }
            );
          };

          TileToolbar toolbar = TileToolbar(onEdit: tileView.onEdit, onFlag: onFlag);
          return Card(
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 5),
              child: Theme(
                data: newTheme,
                child: tileView.editMode ?
                  EditItemTile(item: widget.item) :
                  ViewItemTile(item: widget.item, toolbar: toolbar)
              )
            )
          );
        }
      )
    );
  }
}
