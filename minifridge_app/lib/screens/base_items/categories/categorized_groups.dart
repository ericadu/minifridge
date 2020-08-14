import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/categories/categorized_items.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategorizedGroups extends StatelessWidget {
  final List<BaseItem> foods;
  final List<Category> categories;
  final Function groupBy;
  final ItemScrollController scrollController;
  final ItemPositionsListener positionsListener;
  final int initialIndex;

  CategorizedGroups({
    this.foods,
    this.categories,
    this.groupBy,
    this.scrollController,
    this.positionsListener,
    this.initialIndex
  });

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        Category category = categories[index];
        Map<String, List<BaseItem>> foodsByCategory = groupBy(foods);
        List<BaseItem> foodsInCategory = foodsByCategory.containsKey(category.name) ? foodsByCategory[category.name] : [];

        foodsInCategory.sort(sortBy);
        
        return CategorizedItems(category: category, foods: foodsInCategory, isLast: index == categories.length - 1);
      },
      itemScrollController: scrollController,
      itemPositionsListener: positionsListener,
      initialScrollIndex: initialIndex ?? 0,
    );
  }
}