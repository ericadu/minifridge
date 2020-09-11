import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/providers/tile_view_notifier.dart';
import 'package:minifridge_app/screens/base_items/tile/freshness_timeline.dart';
import 'package:minifridge_app/screens/base_items/tile/tile_toolbar.dart';
import 'package:minifridge_app/services/amplitude.dart';
import 'package:provider/provider.dart';

class ViewItemTile extends StatelessWidget {
  final TileToolbar toolbar;
  final BaseItem item;
  
  ViewItemTile({
    this.item,
    this.toolbar,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, TileViewNotifier tileView, _) {
        return ExpansionTile(
          initiallyExpanded: tileView.expanded,
          title: Text(item.displayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
            )
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              item.freshnessMessage,
              style: TextStyle(
                fontSize: 13
              )
            )
          ),
          onExpansionChanged: (bool expanded) {
            Provider.of<AnalyticsService>(context, listen: false).logEvent(
              'toggle_tile', {
                'type': expanded ? 'expand' : 'collapse'
              }
            );
          },
          children: <Widget>[
            Divider(color: Colors.grey[300]),
            FreshnessTimeline(item: item),
            SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            toolbar
          ]
        );
      }
    );
  }
}