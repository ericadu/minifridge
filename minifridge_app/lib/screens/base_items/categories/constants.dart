import 'package:collection/collection.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/models/category.dart';

Map<String, String> categoryMapping = {
  'Grains':   '🍞',
  'Proteins': '🥩',
  'Fruits': '🍇',
  'Vegetables': '🥒',
  'Dairy & Alternatives': '🥛',
  'Snacks & Sweets': '🍫',
  'Sauces & Spreads': '🍯',
  'Beverages': '🧃',
  'Alcohol': '🍻',
  'Prepared meals': '🍱',
  'Misc': '🥡',
  'Uncategorized': '🏷️'
};

// List<String> names = [
//   'Grains',
//   'Proteins',
//   'Fruits',
//   'Vegetables',
//   'Dairy & Alternatives',
//   'Snacks & Sweets',
//   'Sauces & Spreads',
//   'Beverages',
//   'Alcohol',
//   'Prepared meals',
//   'Misc',
//   'Uncategorized'
// ];

// List<String> emoji = [
//   '🍞',
//   '🥩',
//   '🍇',
//   '🥒',
//   '🥛',
//   '🍫',
//   '🍯',
//   '🧃',
//   '🍻',
//   '🍱',
//   '🥡',
//   '🏷️'
// ];
List<Category> groupings = categoryMapping.entries.map((MapEntry entry) {
  return Category(
    name: entry.key,
    image: entry.value
  );  
}).toList();

// List<Category> groupings = names.asMap().entries.map((MapEntry entry) {
//   return Category(
//     name: entry.value,
//     image: emoji[entry.key]
//   );
// }).toList();

List<Category> perishables = [
  Category(name: 'Perishables', image: '🥑'),
  // Category(name: 'Printed Date', image: '🥛'),
  // Category(name: 'Shelf Stable', image: '🥫'),
  // Category(name: 'Unknown', image: '🏷️')
];

Map<String, List<BaseItem>> groupByCategory(List<BaseItem> foods) {
  return groupBy(foods, (food) => food.category);
}

Map<String, List<BaseItem>> groupByPerishable(List<BaseItem> foods) {
  Map<String, List<BaseItem>> mapByPerishability = {
    'Perishables': [],
    'Printed Date': [],
    'Shelf Stable': [],
    'Unknown': []
  };

  foods.forEach((food) {
    if (food.shelfLife.perishable) {
      mapByPerishability['Perishables'].add(food);
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

int sortBy(BaseItem a, BaseItem b) {
  if (a.shelfLife.perishable && b.shelfLife.perishable) {
    int comparison = -(a.freshness.index.compareTo(b.freshness.index));
    if (comparison == 0) {
      return a.daysFromRangeStart.compareTo(b.daysFromRangeStart);
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
}