import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FreshnessStyle {
  IndicatorStyle indicatorStyle;
  LineStyle topLineStyle;
  LineStyle bottomLineStyle;

  FreshnessStyle({
    this.indicatorStyle,
    this.topLineStyle,
    this.bottomLineStyle,
  });
}

class FreshnessText {
  String weekday;
  String date;
  String title;
  FreshnessText({this.title, this.weekday, this.date});
}

class FreshnessTile extends StatelessWidget {
  final Color inactiveGrey = const Color(0xffd6d6d6);
  final Color activeColor = Colors.teal;
  final FreshnessText text;
  final bool isFirst;
  final bool isUneven;

  FreshnessTile(
    this.text,
    {
      this.isFirst = true,
      this.isUneven = false
    }
  );

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

  @override
  Widget build(BuildContext context) {

    FreshnessStyle style = isUneven ? FreshnessStyle(
      topLineStyle: _lineStyle(true),
      bottomLineStyle: _lineStyle(false),
      indicatorStyle: _indicatorColor(true)
    ) : FreshnessStyle(
      topLineStyle:  _lineStyle(isFirst),
      bottomLineStyle: _lineStyle(isFirst),
      indicatorStyle: _indicatorColor(isFirst)
    );

    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: TimelineTile(
        alignment: TimelineAlign.left,
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
}