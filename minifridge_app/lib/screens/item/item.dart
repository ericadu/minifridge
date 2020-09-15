import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/buttons/report_button.dart';
import 'package:minifridge_app/widgets/freshness/meter.dart';
import 'package:minifridge_app/widgets/text/title.dart';

class ItemPage extends StatelessWidget {
  final BaseItem item;

  ItemPage({
    this.item
  });

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop()
        ),
        shadowColor: Colors.white,
        backgroundColor: AppTheme.themeColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()
          ),
          ReportButton(
            color: Colors.white,
            item: item
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.close,
          color: Colors.white
        ),
        onPressed: () => Navigator.of(context).pop()
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, bottom: 3),
              child: ThemeTitle(item.displayName)
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  Chip(
                    backgroundColor: Colors.grey[300],
                    avatar: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(categoryMapping[item.category]),
                    ),
                    label: Text(item.category),
                    labelPadding: EdgeInsets.only(
                      top: 2, bottom: 2, right: 8
                    ),
                  ),
                ],
              )
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Text('Fresh-O-Meter'),
            ),
            SizedBox(
              height: 150,
              child: FreshnessMeter(
                item: item,
              )
            ),
          ],
        )
      )
    );
  }
}