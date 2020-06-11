import 'package:flutter/material.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

// Behavior: Will show emoji status based on "health of fridge" (kinda like neopets)
// Could have different indicators like
// - empty
// - spoiling (3+ items spoiling?)
// - expired (the worst one)
// - happy (refreshed? lots of shelf life? just ate some spoiling things? just re-stocked?)

class HomeAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Minifridge'),
      floating: false,
      pinned: true,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("🥺", style: TextStyle(fontSize: 60)),
            Text("You have items expiring tomorrow!", style: TextStyle(fontSize: 10))
          ]
        )
      ),
      expandedHeight: 280,

    );
  }
}