import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:minifridge_app/providers/manual_entry_notifier.dart';
import 'package:provider/provider.dart';

class AddItemButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2(
      builder: (BuildContext context, ImagePickerNotifier picker, ManualEntryNotifier manual, _) {
        return FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.grey[700],
            size: 30
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  color: Color(0xFF737373),
                  height: 180,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.photo_camera),
                          title: Text('Take photo'),
                          onTap: () {
                            Navigator.pop(context);
                            picker.pickImage(ImageSource.camera);
                          }
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Choose from library'),
                          onTap: () {
                            Navigator.pop(context);
                            picker.pickImage(ImageSource.gallery);
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
        );
      }
    );
  }
}