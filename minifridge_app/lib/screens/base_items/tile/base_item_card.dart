import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';

class BaseItemCard extends StatelessWidget {
  final BaseItem item;
  final VoidCallback openContainer;

  const BaseItemCard({
    this.item,
    this.openContainer
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          // top: 18, bottom: 20, left: 18
          top: 3, bottom: 5, left: 5
        ),
        child: ListTile(
          title: Text(item.displayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
            )
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              item.freshnessMessage,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black
              )
            )
          ),
          onTap: openContainer
        )
      )
    );
  }
}