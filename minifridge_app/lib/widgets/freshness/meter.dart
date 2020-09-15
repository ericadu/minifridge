import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/widgets/freshness/radial_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FreshnessLabel {
  final String title;
  final String subtitle;
  final String icon;
  final List<GaugeRange> range;

  FreshnessLabel({
    this.title,
    this.subtitle,
    this.icon,
    this.range
  });
}

class FreshnessMeter extends StatelessWidget {
  final BaseItem item;

  FreshnessMeter({
    this.item,
  });

  FreshnessLabel _generateText() {
    Freshness freshness = item.freshness;

    if (!item.shelfLife.perishable){
      return FreshnessLabel(
        title: "Purchased ${item.lifeSoFar} days ago",
        icon: "🏠",
        range: []
      );
    }

    if (freshness == Freshness.not_ready) {
      return FreshnessLabel(
        title: "${-item.lifeSoFar} days until ready",
        icon: "🐛",
        range: [GaugeRange(
          startValue: 0,
          endValue: 120,
          startWidth: 20,
          endWidth: 20,
          gradient: const SweepGradient(
            colors: <Color>[Colors.green, Colors.blue]
          ),
        )]
      );
    } else if (freshness == Freshness.ready) {
      return FreshnessLabel(
        title: "Ready to eat",
        icon: "✅ ",
        range: [GaugeRange(
          startValue: 0,
          endValue: 100,
          startWidth: 20,
          endWidth: 20,
          gradient: const SweepGradient(
            colors: <Color>[Colors.green],
          ),
        )]
      );
    } else if (freshness == Freshness.in_range) {
      return FreshnessLabel(
        title: "Look for signs of expiration",
        icon: "🔎 ",
        range: [GaugeRange(
          startValue: 0,
          endValue: 60,
          startWidth: 20,
          endWidth: 20,
          gradient: const SweepGradient(
            colors: <Color>[Colors.orange, Colors.yellow]
          ),
      )]
      );
    } 
    return FreshnessLabel(
      title: "${item.daysPast} days past expiration",
      icon: "👻 ",
      range: [GaugeRange(
        startValue: 0,
        endValue: 30,
        startWidth: 20,
        endWidth: 20,
        gradient: const SweepGradient(
          colors: <Color>[Colors.redAccent, Colors.orange]
        ),
      )]
    );
  }

  @override
  Widget build(BuildContext context) {
    FreshnessLabel label = _generateText();

    return BaseRadialGauge(
      thickness: 20,
      ranges: label.range,
      annotations: [
        GaugeAnnotation(
          widget: Container(
            child: Text(label.icon, style: TextStyle(fontSize: 24)),
          ),
          angle: 120.0,
          positionFactor: 0.1
        ),
        GaugeAnnotation(
          widget: Container(
            child: Text(label.title),
          ),
          angle: 90.0,
          positionFactor: 1.0
        )
      ],
    );
  }
}