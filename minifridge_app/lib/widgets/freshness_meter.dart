import 'package:flutter/material.dart';

class FreshnessMeter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      min: 0,
      max: 15,
      values: RangeValues(4, 11),
      onChanged: (RangeValues value) {
        print(value);
      },
      semanticFormatterCallback: (RangeValues rangeValues) {
        return '';
      },
      labels: RangeLabels(
        "hello",
        "end"
      ),
      
    );
  }
}