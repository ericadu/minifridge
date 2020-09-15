import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:minifridge_app/screens/base_items/tile/slidable_tile.dart';

class BaseItemsList extends StatelessWidget {
  final List<BaseItem> foods;

  BaseItemsList({
    this.foods
  });

  @override
  Widget build(BuildContext context) {
    foods.sort(sortBy);
    
    return ListView.builder(
      padding: EdgeInsets.only(top: 8),
      itemBuilder: (BuildContext context, index) {
        if (index == foods.length) {
          return SizedBox(height: 90);
        }
        return SlidableTile(
          item: foods[index]
        );
      },
      itemCount: foods.length + 1
    );
}
}