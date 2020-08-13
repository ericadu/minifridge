import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/categories/categorized_items.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategorizedGroups extends StatelessWidget {
  final List<BaseItem> foods;
  final List<Category> categories;
  final Function groupBy;

  CategorizedGroups({
    this.foods,
    this.categories,
    this.groupBy
  });

  @override
  Widget build(BuildContext context) {
    Map<String, List<BaseItem>> foodsByCategory = groupBy(foods);

    return ScrollablePositionedList.builder(
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        Category category = categories[index];
        List<BaseItem> foodsInCategory = foodsByCategory.containsKey(category.name) ? foodsByCategory[category.name] : [];
        
        return CategorizedItems(category: category, foods: foodsInCategory);
      }
    );
  }
}