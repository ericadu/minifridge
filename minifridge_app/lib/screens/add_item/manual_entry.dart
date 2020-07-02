import 'package:flutter/material.dart';

class ManualEntryPage extends StatelessWidget {
  static const routeName = '/manual';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ]
        )
      )
    );
  }
}