import 'package:flutter/material.dart';
import 'package:minifridge_app/widgets/settings_menu.dart';

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
      expandedHeight: 170,
      floating: false,
      pinned: true,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text('foodbase',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            )),
        background: Image.asset(
          "images/hero.png",
          fit: BoxFit.cover
        )
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            showBottomSheet(
              context: context,
              builder: (context) {
                return SettingsMenu();
              }
            );
          },
        ),
      ],
    );
  }
}