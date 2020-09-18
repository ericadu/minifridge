import 'package:flutter/material.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:minifridge_app/providers/manual_entry_notifier.dart';
import 'package:minifridge_app/theme.dart';
import 'package:provider/provider.dart';

class AddItemButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2(
      builder: (BuildContext context, ImagePickerNotifier picker, ManualEntryNotifier manual, _) {
        return Container(
          height: 70,
          width: 120,
          child: FittedBox(
            child: FloatingActionButton.extended(
              backgroundColor: Colors.white,
              elevation: 8,
              icon: Icon(
                Icons.add,
                color: AppTheme.lightSecondaryColor,
                size: 30
              ),
              label: Text("Add"),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: Color(0xFF737373),
                      height: 120,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo_camera),
                              title: Text('Add From Photo'),
                              onTap: () {
                                Navigator.pop(context);
                                picker.pickImages();
                              }
                            ),
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Add Manually'),
                              onTap: () {
                                Navigator.pop(context);
                                manual.show();
                              }
                            ),
                          ]
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10),
                            topRight: const Radius.circular(10)
                          )
                        )
                      ),
                    );
                  }
                );
              },
            )
          )
        );
      }
    );
  }
}