import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  static const routeName = '/add';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item')
      ),
      body: Text("ADD")
    );
  }
}