import 'package:flutter/material.dart';
import 'package:minifridge_app/theme.dart';

class TileToolbar extends StatelessWidget {
  final Function onEdit;
  final Function onFlag;

  TileToolbar({
    this.onEdit,
    this.onFlag
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor orange = AppTheme.generateMaterialColor(AppTheme.lightSecondaryColor);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            iconSize: 24,
            icon: Icon(Icons.edit, color: orange),
            onPressed: onEdit
          )
        ),
        Container(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            iconSize: 24,
            icon: Icon(Icons.flag, color: orange),
            onPressed: onFlag
          )
        )
      ],
    );
  }
}