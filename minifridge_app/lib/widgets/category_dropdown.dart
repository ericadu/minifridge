import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final Function onChanged;

  CategoryDropdown({
    this.value,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> _dropdownMenuItems = names.map((name) {
      return DropdownMenuItem(
        child: Text(name),
        value: name
      );
    }).toList();
    return DropdownButton<String>(
      value: value,
      items: _dropdownMenuItems,
      onChanged: onChanged
    );
  }
}