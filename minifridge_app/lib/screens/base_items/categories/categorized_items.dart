import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/tile/slidable_tile.dart';

class CategorizedItems extends StatelessWidget {
  final Category category;
  final List<BaseItem> foods;

  CategorizedItems({
    this.category,
    this.foods
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [
      SizedBox(
        height: 70,
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Card(
            child: Container(
              
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(category.image, style: TextStyle(fontSize: 20))
                  ),
                  Text(category.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  )
                ]
              ),
            )
          )
        )
      )
    ];

    if (foods.length > 0) {
      foods.forEach((item) {
        slivers.add(SlidableTile(item: item));
      });
    } else {
      slivers.add(
        Container(
          height: 100,
          alignment: Alignment.center,
          child: Text('No items in category ${category.name}')
        )
      );
    }

    slivers.add(
      SizedBox(height: 20)
    );
    
    return Column(
      children: slivers
    );
  }
}