import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FreshnessMeter extends StatelessWidget {
  final List<GaugeAnnotation> annotations;
  final List<GaugeRange> ranges;
  final double thickness;

  FreshnessMeter({
    this.thickness,
    this.annotations,
    this.ranges
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          annotations: annotations,
          showLabels: false,
          showTicks: false,
          minimum: 0,
          maximum: 120,
          startAngle: 150,
          endAngle: 30,
          ranges: ranges,
          axisLineStyle: AxisLineStyle(
            thickness: thickness
          )
        )
      ],
      
    );
  }
}