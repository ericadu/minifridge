import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FreshnessText {
  String date;
  String title;
  String subtitle;

  FreshnessText({this.title, this.subtitle, this.date});
}

class FreshnessStyle {
  IndicatorStyle indicatorStyle;
  LineStyle topLineStyle;
  LineStyle bottomLineStyle;
  bool isFirst;
  bool isLast;

  FreshnessStyle({
    this.indicatorStyle,
    this.topLineStyle,
    this.bottomLineStyle,
    this.isFirst,
    this.isLast,
  });
}

class FreshnessTimeline extends StatelessWidget {
  final BaseItem item;
  final Color inactiveGrey = const Color(0xffd6d6d6);
  final Color activeColor = Colors.teal;

  FreshnessTimeline({
    this.item
  });

  IndicatorStyle _indicatorColor(bool active) {
    if (active) {
      return IndicatorStyle(
        width: 18,
        indicatorY: 0.5,
        color: activeColor
      );
    }

    return  IndicatorStyle(
      width: 16,
      indicatorY: 0.5,
      color: inactiveGrey
    );
  }

  LineStyle _lineStyle(bool active) {
    if (active) {
      return LineStyle(
        color: activeColor,
        width: 6,
      );
    }

    return LineStyle(
      color: inactiveGrey,
    );
  }

  FreshnessStyle _getStyle(BaseItem item, bool top) {
    if (item.getFreshness() == Freshness.past) {
      if (top) {
        return FreshnessStyle(
          isFirst: true,
          isLast: false,
          indicatorStyle: _indicatorColor(true),
          bottomLineStyle: _lineStyle(true),
          topLineStyle: _lineStyle(true)
        );
      }

      return FreshnessStyle(
        isFirst: false,
        isLast: false,
        indicatorStyle: _indicatorColor(true),
        bottomLineStyle: _lineStyle(false),
        topLineStyle: _lineStyle(true)
      );
    }

    return FreshnessStyle(
      isFirst: false,
      isLast: !top,
      indicatorStyle: _indicatorColor(top),
      bottomLineStyle: _lineStyle(top),
      topLineStyle: _lineStyle(top)
    );
  }

  

  FreshnessText _topText(BaseItem item) {
    Freshness freshness = item.getFreshness();
    int days = item.getDays();

    if (freshness == Freshness.not_ready) {
      return FreshnessText(
        title: "${-item.getLifeSoFar()} days until ready.",
        date: "Today"
      );
    } else if (freshness == Freshness.ready) {
      return FreshnessText(
        title: "✅  Ready to eat",
        date: "Today"
      );
    } else if (freshness == Freshness.in_range) {
      String sub = days == 0 ? "Day 1 in expiration zone." : "${-days} days in expiration zone.";
      return FreshnessText(
        title: "🔎  Look for signs",
        subtitle: sub,
        date: "Today"
      );
    }

    return FreshnessText(
      title: "👻  To the after life",
      date: DateFormat.MEd().format(item.expirationDate())
    );
  }

  FreshnessText _bottomText(BaseItem item) {
    Freshness freshness = item.getFreshness();

    if (freshness == Freshness.not_ready) {
      return FreshnessText(
        title: "✅ Ready to eat",
        date: DateFormat.MEd().format(item.referenceDatetime())
      );
    } else if (freshness == Freshness.ready) {
      return FreshnessText(
        title: "🔎  Look for signs",
        date: DateFormat.MEd().format(item.rangeStartDate())
      );
    } else if (freshness == Freshness.in_range) {
      return FreshnessText(
        title: "👻  To the after life",
        date: DateFormat.MEd().format(item.expirationDate())
      );
    }

    return FreshnessText(
      title: "${item.getDaysPast()} days since passed.",
      date: "Today"
    );
  }

  Widget _buildTile(FreshnessText text, FreshnessStyle style) {
    return Container(
      // padding: const EdgeInsets.only(left: 20),
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        isFirst: style.isFirst,
        isLast: style.isLast,
        lineX: 0.32,
        topLineStyle: style.topLineStyle,
        indicatorStyle: style.indicatorStyle,
        bottomLineStyle: style.bottomLineStyle,
        leftChild: Padding(
          padding: EdgeInsets.only(left: 8, right: 20),
          child: Container(
              alignment: Alignment.centerRight,
              child: Text(text.date, style: TextStyle(fontWeight: FontWeight.bold))
            ),
        ),
        rightChild: text.subtitle != null ? Container(
          constraints: const BoxConstraints(
            minHeight: 70,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text.title, style: TextStyle(fontSize: 17)),
                Padding(
                  padding: EdgeInsets.only(top:5, left: 27),
                  child: Text(text.subtitle)
                )
              ],
            )
          )
        ) : Container(
          constraints: const BoxConstraints(
            minHeight: 55,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 18, left: 20),
            child: Text(text.title, style: TextStyle(fontSize: 17))
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    FreshnessText topText = _topText(item);
    FreshnessText bottomText = _bottomText(item);
    FreshnessStyle topStyle = _getStyle(item, true);
    FreshnessStyle bottomStyle = _getStyle(item, false);
    return Column(
      children: [
        _buildTile(topText, topStyle),
        _buildTile(bottomText, bottomStyle)
      ]
    );
  }
}