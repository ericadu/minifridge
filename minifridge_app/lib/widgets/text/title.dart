import 'package:flutter/material.dart';

class ThemeTitle extends StatelessWidget {
  final String text;

  ThemeTitle(
    this.text
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        // horizontal: 20
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        )
      )
    );
  }
}