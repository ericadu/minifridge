import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/home/home_app_bar.dart';

class EmptyBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        HomeAppBar(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text("🍩", style: TextStyle(fontSize: 50)),
                  ),
                  Text("You do-nut have any items!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 45, right: 20),
                    child: Text("📷  Upload a photo of your last grocery receipt to add food.",
                      style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 50),
                    child: Image.asset(
                      "images/arrow.png",
                      scale: 3.5,
                    )
                  )
                ]
              ),
            )
          )
        )
      ]
    );
  }
}