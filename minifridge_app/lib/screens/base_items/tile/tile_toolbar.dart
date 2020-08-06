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
            iconSize: 32,
            icon: Icon(Icons.edit, color: orange),
            onPressed: onEdit
            // onPressed: () {
            //   setState(() {
            //     view = false;
            //     expanded = true;
            //   });                  
            // }
          )
        ),
        Container(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            iconSize: 32,
            icon: Icon(Icons.flag, color: orange),
            onPressed: onFlag
            // onPressed: () {
            //   expanded = true;
            //   showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return ReportAlertDialog(itemId: item.id, onSubmit: showSuccessBar);
            //     }
            //   );               
            // }
          )
        )
      ],
    );
  }
}