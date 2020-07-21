import 'package:flutter/material.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:provider/provider.dart';

class AddItemButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ImagePickerNotifier picker, _) {
        return Visbility(
          child: Container(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.grey[700],
                size: 30
              ),
              onPressed: () {
                setState(() {
                  showAddButton = false;
                });

                PersistentBottomSheetController bottomSheetController = showBottomSheet(
                  elevation: 100.0,
                  context: context,
                  builder: (context) => Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10)
                      )
                    )
                  )
                );

                bottomSheetController.closed.then((value) {
                  setState(() {
                    showAddButton = true;
                  });
                  // this callback will be executed on close
                });
              },
            )
          )
        );
      }
    );
  }
}