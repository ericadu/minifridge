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
  Category(name: 'Non-perishable', image: '🥫'),
  Category(name: 'Unknown', image: '🏷️')
];