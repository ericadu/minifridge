import 'package:flutter/material.dart';
import 'package:minifridge_app/theme.dart';

class EditItemHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom:20),
      child: Text(
        "Editing",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.lightSecondaryColor)
      )
    );
  }
}