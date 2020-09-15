import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/screens/base_items/report_alert_dialog.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/freshness/meter.dart';

class ViewItemTile extends StatefulWidget {
  final BaseItem item;
  final VoidCallback openContainer;
  
  ViewItemTile({
    this.item,
    this.openContainer
  });

  @override
  _ViewItemTileState createState() => _ViewItemTileState();
}

class _ViewItemTileState extends State<ViewItemTile> {
  bool expanded = false;

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
    return ExpansionTile(
      title: Text(widget.item.displayName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black
        )
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          widget.item.freshnessMessage,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black
          )
        )
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          expanded = expanded;
        });
        // Provider.of<AnalyticsService>(context, listen: false).logEvent(
        //   'toggle_tile', {
        //     'type': expanded ? 'expand' : 'collapse'
        //   }
        // );
      },
      // trailing: Icon(Icons.unfold_more),
      children: <Widget>[
        SizedBox(
          height: 140,
          child: FreshnessMeter(
            item: widget.item,
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10, right: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  RawMaterialButton(
                    child: Icon(Icons.edit, color: Colors.white),
                    onPressed: widget.openContainer,
                    fillColor: AppTheme.themeColor,
                    shape: CircleBorder(),
                    constraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 40
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ]
    );
  }
}
