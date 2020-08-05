import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FreshnessText {
  String weekday;
  String date;
  String title;
  FreshnessText({this.title, this.weekday, this.date});
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
        width: 15,
        indicatorY: 0.4,
        color: activeColor
      );
    }

    return  IndicatorStyle(
      width: 15,
      indicatorY: 0.5,
      color: inactiveGrey
    );
  }

  LineStyle _lineStyle(bool active) {
    if (active) {
      return LineStyle(
        color: activeColor,
        width: 5,
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
          isFirst: false,
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
      isLast: false,
      indicatorStyle: _indicatorColor(top),
      bottomLineStyle: _lineStyle(top),
      topLineStyle: _lineStyle(top)
    );
  }

  FreshnessText _topText(BaseItem item) {
    Freshness freshness = item.getFreshness();
    int days = item.getDays();
    // String today = "Today, ${DateFormat.Md().format(DateTime.now())}";
    String weekday = "Today";
    String date = DateFormat.Md().format(DateTime.now());

    if (freshness == Freshness.not_ready) {
      return FreshnessText(
        title: "🐛 ${-item.getLifeSoFar()} days until ready.",
        weekday: weekday,
        date: date
      );
    } else if (freshness == Freshness.ready) {
      return FreshnessText(
        title: "✅  Ready to eat",
        weekday: weekday,
        date: date
      );
    } else if (freshness == Freshness.in_range) {
      String sub = days == 0 ? "First day in expiration zone." : "${-days + 1} days in expiration zone.";
      return FreshnessText(
        title: "🔎  Look for signs of expiration",
        date: date,
        weekday: weekday
      );
    }

    return FreshnessText(
      title: "👻  To the after life",
      date: DateFormat.Md().format(item.expirationDate()),
      weekday: DateFormat.EEEE().format(item.expirationDate())
    );
  }

  FreshnessText _bottomText(BaseItem item) {
    Freshness freshness = item.getFreshness();
    if (freshness == Freshness.not_ready) {
      return FreshnessText(
        title: "✅  Ready to eat",
        date: DateFormat.Md().format(item.referenceDatetime()),
        weekday: DateFormat.EEEE().format(item.referenceDatetime())
      );
    } else if (freshness == Freshness.ready) {
      return FreshnessText(
        title: "🔎  Look for signs of expiration",
        date: DateFormat.Md().format(item.rangeStartDate()),
        weekday: DateFormat.E().format(item.rangeStartDate())
      );
    } else if (freshness == Freshness.in_range) {
      return FreshnessText(
        title: "👻  To the after life",
        date: DateFormat.Md().format(item.expirationDate()),
        weekday: DateFormat.EEEE().format(item.expirationDate())
      );
    }

    return FreshnessText(
      title: "${item.getDaysPast()} days since passed expiration.",
      date: "${DateFormat.Md().format(DateTime.now())}",
      weekday: "Today"
    );
  }

  Widget _buildTile(FreshnessText text, FreshnessStyle style, Alignment alignment) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: TimelineTile(
        alignment: TimelineAlign.left,
        isFirst: style.isFirst,
        isLast: style.isLast,
        topLineStyle: style.topLineStyle,
        indicatorStyle: style.indicatorStyle,
        bottomLineStyle: style.bottomLineStyle,

        rightChild: Container(
          constraints: const BoxConstraints(
            minHeight: 70,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${text.weekday}, ${text.date}".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text(text.title, style: TextStyle(fontSize: 15)),
                  ],
                ),
              ],
            )
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
        SizedBox(height: 10),
        _buildTile(topText, topStyle, Alignment.centerLeft),
        _buildTile(bottomText, bottomStyle, Alignment.centerLeft)
      ]
    );
  }
}