import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/widgets/text/title.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ItemPage extends StatelessWidget {
  final BaseItem item;

  ItemPage({
    this.item
  });

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop()
        ),
        shadowColor: Colors.white,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ThemeTitle(item.displayName)
            ),
            SizedBox(
              height: 120,
              child: SfRadialGauge(
                axes: [
                  RadialAxis(
                    showLabels: false,
                    showTicks: false,
                    // startAngle: 180,
                    // endAngle: 0,
                    // radiusFactor: 0.6,
                    canScaleToFit: true,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.25,
                      color: const Color.fromARGB(30, 0, 169, 181),
                      thicknessUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.bothCurve,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                      value: 80,
                      width: 0.25,
                      sizeUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.bothCurve)
                    ]
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }
}