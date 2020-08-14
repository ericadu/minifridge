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
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';

class ManualAddRightButton extends StatelessWidget {
  final VoidCallback callback;

  const ManualAddRightButton({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3(
      builder: (BuildContext context, ManualEntryNotifier manual, BaseNotifier base, AuthNotifier user, _) {
        if (manual.currentStep + 1 == manual.stepLength) {
          return Container(
            color: AppTheme.lightTheme.accentColor,
            child: FlatButton(
              child: Text("Submit", style: TextStyle(color: Colors.white)),
              onPressed: () {
                DateTime today = DateTime.now();
                ShelfLife shelfLife = ShelfLife(perishable: false);
                if (isNotEmpty(manual.expDate)) {
                  shelfLife = ShelfLife(
                    dayRangeStart: DateFormat.yMMMEd().parse(manual.expDate).difference(today),
                    perishable: true
                  );
                }
                BaseItem item = BaseItem(
                  displayName: manual.itemName,
                  category: manual.category,
                  quantity: 1,
                  unit: 'item',
                  buyTimestamp: Timestamp.fromDate(today),
                  referenceTimestamp: Timestamp.fromDate(today),
                  addedByUserId: Provider.of<AuthNotifier>(context, listen: false).user.uid,
                  shelfLife: shelfLife,
                  endType: EndType.alive,
                );

                base.addNewItem(item.toJson()).then((doc) {
                  // TODO: figure out why this doesn't work
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Success! 🎉 ${manual.itemName} added to base."),
                    )
                  );
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