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
    List<DropdownMenuItem<String>> _dropdownMenuItems = categoryMapping.keys.map((name) {
      return DropdownMenuItem(
        child: Chip(
          backgroundColor: Colors.grey[300],
          avatar: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Text(categoryMapping[name]),
          ),
          label: Text(name, style: TextStyle(fontSize: 14)),
          labelPadding: EdgeInsets.only(
            top: 2, bottom: 2, right: 8
          ),
        ),
        value: name
      );
    }).toList();
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        items: _dropdownMenuItems,
        onChanged: onChanged, 
      )
    );
  }
}