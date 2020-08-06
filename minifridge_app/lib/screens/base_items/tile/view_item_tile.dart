import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/screens/base_items/tile/freshness_timeline.dart';
import 'package:minifridge_app/screens/base_items/tile/tile_toolbar.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:provider/provider.dart';

class ViewItemTile extends StatelessWidget {
  final bool expanded;
  final TileToolbar toolbar;
  final BaseItem item;
  
  ViewItemTile({
    this.item,
    this.toolbar,
    this.expanded
  });

  String _getMessage(BaseItem item) {
    String message;
    if (item.shelfLife.perishable) {
      Freshness freshness = item.getFreshness();
      switch(freshness) {
        case Freshness.in_range:
          message = "⏰ Eat me next";
          break;
        case Freshness.ready:      
          if (item.getDays() == 1) {
            message = "⏳  1 day left";
          } else if (item.getDays() > 7) {
            message = "💚​  Fresh AF";
          } else {
            message = "⏳  ${item.getDays()} days left";
          }
          break;
        case Freshness.past:
          message = "😬  Caution";
          break;
        case Freshness.not_ready:
          message = "🐣  Not quite ready";
          break;
        default:
          message = "⏳  " + item.getDays().toString() + " days left";
      }
    } else {
      message = "🦄  Forever young";
    }

    return message;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: expanded,
      title: Text(item.displayName,
        style: const TextStyle(
          fontWeight: FontWeight.bold
        )
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(_getMessage(item))
      ),
      onExpansionChanged: (bool expanded) {
        analytics.logEvent(name: 'expand_item', parameters: {
          'item': item.displayName,
          'action': expanded ? 'expand' : 'collapse',
          'user': Provider.of<AuthNotifier>(context, listen:false).user.uid
        });
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
}