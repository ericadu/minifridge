import 'package:collection/collection.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/category.dart';

List<String> names = [
  'Grains',
  'Proteins',
  'Fruits',
  'Vegetables',
  'Dairy & Substitutes',
  'Snacks & Sweets',
  'Sauces & Spreads',
  'Beverages',
  'Alcohol',
  'Supplements',
  'Prepared meals',
  'Misc',
  'Uncategorized'
];

List<String> emoji = [
  '🍞',
  '🍖',
  '🍓',
  '🥬',
  '🧀',
  '🍿',
  '🍯',
  '🧃',
  '🍺',
  '💊',
  '🍱',
  '🥡',
  '🏷️'
];

List<Category> categories = names.asMap().entries.map((MapEntry entry) {
  return Category(
    name: entry.value,
    image: emoji[entry.key]
  );
}).toList();

List<Category> perishables = [
  Category(name: 'Perishable', image: '🥑'),
  Category(name: 'Printed Date', image: '🥛'),
  Category(name: 'Shelf Stable', image: '🥫'),
  Category(name: 'Unknown', image: '🏷️')
];

Map<String, List<BaseItem>> groupByCategory(List<BaseItem> foods) {
  return groupBy(foods, (food) => food.category);
}

Map<String, List<BaseItem>> groupByPerishable(List<BaseItem> foods) {
  Map<String, List<BaseItem>> mapByPerishability = {
    'Perishable': [],
    'Printed Date': [],
    'Shelf Stable': [],
    'Unknown': []
  };

  foods.forEach((food) {
    if (food.shelfLife.perishable) {
      mapByPerishability['Perishable'].add(food);
    }

    else if (food.shelfLife.perishable == false) {
      mapByPerishability['Shelf Stable'].add(food);
    }

    else {
      mapByPerishability['Unknown'].add(food);
    }
  });

  return mapByPerishability;
}

