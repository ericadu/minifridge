import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/providers/base_notifier.dart';
import 'package:minifridge_app/screens/base_items/base_item_tile.dart';
import 'package:minifridge_app/theme.dart';
import 'package:provider/provider.dart';

class SlidableTile extends StatelessWidget {
  final BaseItem item;

  SlidableTile({
    this.item
  });

  void onRemove(BaseNotifier base, BuildContext context, String message, EndType endtype) {
    base.updateEndtype(item, endtype);

    Scaffold
      .of(context)
      .showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: "Undo",
            textColor: Colors.yellow,
            onPressed: () {
              base.updateEndtype(item, EndType.alive);
            }
          )
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, BaseNotifier base, _) {
        return Slidable(
          key: UniqueKey(),
          actionPane: SlidableDrawerActionPane(),
          child: BaseItemTile(item: item),
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            dismissThresholds: <SlideActionType, double>{
              SlideActionType.primary: 1.0
            },
            onDismissed: (actionType) => onRemove(
              base,
              context,
              "Yum! ${item.displayName} eaten 😋",
              EndType.eaten
            ) 
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'All',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => onRemove(
                base,
                context,
                "${item.displayName} thrown away 😓",
                EndType.thrown
              )
            ),
            IconSlideAction(
              caption: "Partial",
              color: AppTheme.orange,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              onTap: () => onRemove(
                base,
                context,
                "So close! ${item.displayName} partially eaten 🤭",
                EndType.partial
              )
            )
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Eat',
              color: Colors.green,
              icon: Icons.local_dining,
              onTap: () => onRemove(
                base,
                context,
                "Yum! ${item.displayName} eaten 😋",
                EndType.eaten
              ) 
            )
          ]
        );
      }
    );
  }
}