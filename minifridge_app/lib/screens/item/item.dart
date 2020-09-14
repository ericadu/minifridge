import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/freshness/meter.dart';
import 'package:minifridge_app/widgets/text/title.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ItemPage extends StatelessWidget {
  final BaseItem item;

  ItemPage({
    this.item
  });

  Widget build(BuildContext context) {

    List<GaugeAnnotation> annotations = <GaugeAnnotation>[
      GaugeAnnotation(
        widget: Container(
          child: Text('👻', style: TextStyle(fontSize: 23)),
        ),
        angle: 90.0,
        positionFactor: 0.1
      ),
      GaugeAnnotation(
        widget: Container(
          child: Text('To the after life'),

        ),
        angle: 90.0,
        positionFactor: 1.0
      )
    ];

    List<GaugeRange> ranges = [
      GaugeRange(
        startValue: 0,
        endValue: 30,
        startWidth: 20,
        endWidth: 20,
        gradient: const SweepGradient(
          colors: <Color>[Colors.redAccent, Colors.orange]
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop()
        ),
        shadowColor: Colors.white,
        backgroundColor: AppTheme.themeColor,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, bottom: 3),
              child: ThemeTitle(item.displayName)
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  Chip(
                    backgroundColor: Colors.grey[300],
                    avatar: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(categoryMapping[item.category]),
                    ),
                    label: Text(item.category),
                    labelPadding: EdgeInsets.only(
                      top: 2, bottom: 2, right: 8
                    ),
                  ),
                ],
              )
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Text('Fresh-O-Meter'),
            ),
            SizedBox(
              height: 150,
              child: FreshnessMeter(
                thickness: 20,
                annotations: annotations,
                ranges: ranges
              )
            ),
          ],
        )
      )
    );
  }
}