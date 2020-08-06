import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/widgets/tile/freshness_tile.dart';

class FreshnessTimeline extends StatelessWidget {
  final BaseItem item;

  FreshnessTimeline({
    this.item
  });

  FreshnessText _generateText(String text, DateTime date) {
    DateTime now = DateTime.now();
    bool today = DateTime(now.year, now.month, now.day) == DateTime(date.year, date.month, date.day);

    return FreshnessText(
      title: text,
      date: DateFormat.Md().format(date),
      weekday: today ? "Today" : DateFormat.EEEE().format(date)
    );
  }

  FreshnessText _topText(BaseItem item) {
    Freshness freshness = item.getFreshness();
    DateTime today = DateTime.now();

    if (freshness == Freshness.not_ready) {
      return _generateText("🐛 ${-item.getLifeSoFar()} days until ready.", today);

    } else if (freshness == Freshness.ready) {
      return _generateText("✅  Ready to eat", today);
    } else if (freshness == Freshness.in_range) {
      return _generateText("🔎  Look for signs of expiration", today);
    }
    return _generateText("👻  To the after life", item.expirationDate());
  }

  FreshnessText _bottomText(BaseItem item) {
    Freshness freshness = item.getFreshness();
    if (freshness == Freshness.not_ready) {
      return _generateText("✅  Ready to eat", item.referenceDatetime());
    } else if (freshness == Freshness.ready) {
      return _generateText("🔎  Look for signs of expiration", item.rangeStartDate());
    } else if (freshness == Freshness.in_range) {
      return _generateText("👻  To the after life", item.expirationDate());
    }
    return _generateText("${item.getDaysPast()} days since passed expiration.", DateTime.now());
  }

  FreshnessText _nonPerishableText(BaseItem item) {
    return _generateText("🏠 Purchase date", item.buyDatetime());
  }

  @override
  Widget build(BuildContext context) {
    if (item.shelfLife.perishable) {
      FreshnessText topText = _topText(item);
      FreshnessText bottomText = _bottomText(item);

      return Column(
        children: [
          SizedBox(height: 10),
          FreshnessTile(topText),
          FreshnessTile(bottomText, isFirst: false, isUneven: item.getFreshness() == Freshness.past)
        ]
      );
    }
    
    return Column(
      children: [
        SizedBox(height: 10),
        FreshnessTile(_generateText("🏠  Purchase date", item.buyDatetime())),
      ],
    );
  }
}