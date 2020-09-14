import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/screens/base_items/report_alert_dialog.dart';
import 'package:minifridge_app/theme.dart';

class ReportButton extends StatelessWidget {
  final BaseItem item;
  final Color color;

  ReportButton({
    this.color,
    this.item
  });

  @override
  Widget build(BuildContext context) {
    Function showSuccessBar = () => {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Report submitted!"),
          backgroundColor: AppTheme.lightSecondaryColor,
        )
      )
    };

    return IconButton(
      icon: Icon(Icons.flag, color: color),
      onPressed: () => {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ReportAlertDialog(itemId: item.id, onSubmit: showSuccessBar);
          }
        )
      }
    );
  }
}