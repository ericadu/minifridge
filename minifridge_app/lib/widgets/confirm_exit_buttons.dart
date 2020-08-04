import 'package:flutter/material.dart';

class ConfirmExitButtons extends StatelessWidget {
  final Function onCancel;
  final Function onConfirm;

  const ConfirmExitButtons({this.onCancel, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10)
              )
            )
          ),
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: onCancel
          )
        ),
        Ink(
          decoration: ShapeDecoration(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)
              )
            )
          ),
          child: IconButton(
            icon: Icon(Icons.done, color: Colors.white),
            onPressed: onConfirm
          )
        )
      ],
    );
  }
}