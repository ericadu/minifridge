import 'package:flutter/material.dart';

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
      // title: Text('Minifridge'),
      floating: false,
      pinned: true,
      snap: false,
      // flexibleSpace: FlexibleSpaceBar(
      //   title: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       // Text("🥺", style: TextStyle(fontSize: 60)),
      //       Text("Minifridge")
      //     ]
      //   )
      // ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text('minifridge',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            )),
        background: Image.network(
          'https://user-images.githubusercontent.com/1338639/84708077-d16a1180-af2d-11ea-9e14-3ca8938acd41.png',
          fit: BoxFit.cover,
        )
      ),
      expandedHeight: 200,
    );
  }
}