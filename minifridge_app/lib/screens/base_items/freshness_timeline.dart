import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FreshnessTimeline extends StatelessWidget {
  final BaseItem item;

  FreshnessTimeline({
    this.item
  });

  List<Widget> _buildTiles() {
    const Color inactiveGrey = const Color(0xffd6d6d6);
    const Color activeColor = Colors.teal;

    IndicatorStyle activeIndicator = const IndicatorStyle(
      width: 18,
      indicatorY: 0.5,
      color: activeColor
    );

    LineStyle activeLine = const LineStyle(
      color: activeColor,
      width: 6,
    );

    IndicatorStyle inactiveIndicator = const IndicatorStyle(
      width: 16,
      indicatorY: 0.5,
      color: inactiveGrey
    );

    LineStyle inactiveLine = const LineStyle(
      color: inactiveGrey,
    );
    Freshness freshness = item.getFreshness();
    return [
      Padding(
          padding: const EdgeInsets.only(left: 30, top: 3),
          child: TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.3,
            topLineStyle: activeLine,
            indicatorStyle: freshness.index > 0 ? activeIndicator : inactiveIndicator,
            bottomLineStyle: freshness.index > 1 ? activeLine : inactiveLine,
            leftChild: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Container(
                  child: Text(DateFormat.MEd().format(item.referenceDatetime()))
                ),
            ),
            rightChild: Container(
              constraints: const BoxConstraints(
                minHeight: 55,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 18, left: 25),
                child: Text("✅  Ready to eat", style: TextStyle(fontSize: 17))
              )
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child:TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.3,
            topLineStyle: freshness.index > 2 ? activeLine : inactiveLine,
            indicatorStyle: freshness.index > 3 ? activeIndicator : inactiveIndicator,
            bottomLineStyle: freshness.index > 4 ? activeLine : inactiveLine,
            leftChild: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                child: Text(DateFormat.MEd().format(item.rangeStartDate()))
              ),
            ),
            rightChild: Container(
              constraints: const BoxConstraints(
                minHeight: 70,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("🔎  Look for signs", style: TextStyle(fontSize: 17)),
                    Padding(
                      padding: EdgeInsets.only(top:5, left: 27),
                      child: Text("In expiration zone")
                    )
                  ],
                )
              )
            )
          )
        ),
        if (item.hasRange())
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child:TimelineTile(
              alignment: TimelineAlign.manual,
              lineX: 0.3,
              topLineStyle: freshness.index > 5 ? activeLine : inactiveLine,
              indicatorStyle: freshness.index > 6 ? activeIndicator : inactiveIndicator,
              bottomLineStyle: freshness.index > 7 ? activeLine : inactiveLine,
              leftChild: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: Text(DateFormat.MEd().format(item.rangeEndDate()))
                ),
              ),
              rightChild: Container(
                constraints: const BoxConstraints(
                  minHeight: 60,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 25),
                      child: Text("👻  To the after life", style: TextStyle(fontSize: 17))
                    )
                  ]
                )
              )
            )
          )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildTiles(),
    );
  }
}