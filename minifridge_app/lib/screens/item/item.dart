import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/screens/item/edit_item.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/buttons/report_button.dart';

class ItemPage extends StatelessWidget {
  final BaseItem item;
  final FoodBaseApi api;

  ItemPage({
    this.item,
    this.api
  });

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
            item: item
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white
        ),
        onPressed: () => Navigator.of(context).pop()
      ),
      body: Container(
        color: Colors.white,
        child: Text('hi')
      )
    );
  }
}