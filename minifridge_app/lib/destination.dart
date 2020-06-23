
import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/settings.dart';
import 'package:minifridge_app/screens/user_items/user_items.dart';

class Destination {
  const Destination(this.title, this.icon, this.routeName, this.index);

  final String title;
  final IconData icon;
  final String routeName;
  final int index;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Items', Icons.kitchen, UserItemsPage.routeName, 0),
  Destination('Settings', Icons.settings, SettingsPage.routeName, 1)
];
