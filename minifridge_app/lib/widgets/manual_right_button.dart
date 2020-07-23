import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/models/shelf_life.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/providers/base_items_notifier.dart';
import 'package:minifridge_app/providers/manual_entry_notifier.dart';
import 'package:minifridge_app/theme.dart';
import 'package:provider/provider.dart';

class ManualAddRightButton extends StatelessWidget {
  final VoidCallback callback;

  const ManualAddRightButton({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3(
      builder: (BuildContext context, ManualEntryNotifier manual, BaseItemsNotifier base, AuthNotifier user, _) {
        if (manual.currentStep + 1 == manual.stepLength) {
          return Container(
            color: AppTheme.lightTheme.accentColor,
            child: FlatButton(
              child: Text("Submit", style: TextStyle(color: Colors.white)),
              onPressed: () {
                DateTime today = DateTime.now();
                DateTime expDate = DateFormat.yMMMEd().parse(manual.expDate);
                print(expDate.toString());
                BaseItem item = BaseItem(
                  displayName: manual.itemName,
                  quantity: 1,
                  unit: 'item',
                  buyTimestamp: Timestamp.fromDate(today),
                  referenceTimestamp: Timestamp.fromDate(today),
                  addedByUserId: Provider.of<AuthNotifier>(context, listen: false).user.uid,
                  shelfLife: ShelfLife(dayRangeStart: expDate.difference(today)),
                  endType: EndType.alive,
                );

                base.addNewItem(item.toJson()).then((doc) {
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
    );
  }
}