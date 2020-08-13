import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/categories/categorized_items.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategorizedGroups extends StatelessWidget {
  final List<BaseItem> foods;
  final List<Category> categories;
  final Function groupBy;
  final ItemScrollController scrollController;
  final ItemPositionsListener positionsListener;

  CategorizedGroups({
    this.foods,
    this.categories,
    this.groupBy,
    this.scrollController,
    this.positionsListener
  });

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        Category category = categories[index];
        Map<String, List<BaseItem>> foodsByCategory = groupBy(foods);
        List<BaseItem> foodsInCategory = foodsByCategory.containsKey(category.name) ? foodsByCategory[category.name] : [];

        foodsInCategory.sort((a, b) {
          if (a.shelfLife.perishable && b.shelfLife.perishable) {
            int comparison = -(a.getFreshness().index.compareTo(b.getFreshness().index));
            if (comparison == 0) {
              return a.getDays().compareTo(b.getDays());
            }
            return comparison;
          } else {
            if (a.shelfLife.perishable) {
              return -1;
            }

            if (b.shelfLife.perishable) {
              return 1;
            }

            return a.displayName.compareTo(b.displayName);
          }
        });
        
        return CategorizedItems(category: category, foods: foodsInCategory);
      },
      itemScrollController: scrollController,
      itemPositionsListener: positionsListener
    );
  }
}