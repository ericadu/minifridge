import 'package:flutter/material.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Behavior: Will show emoji status based on "health of fridge" (kinda like neopets)
// Could have different indicators like
// - empty
// - spoiling (3+ items spoiling?)
// - expired (the worst one)
// - happy (refreshed? lots of shelf life? just ate some spoiling things? just re-stocked?)

class HomeAppBar extends StatelessWidget {

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          "images/minifridge_home_hero.png",
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
                return Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("🍑  What's in season?"),
                          onTap: () {
                            launchURL("https://www.seasonalfoodguide.org");
                          }
                        ),
                        ListTile(
                          title: Text('👋  Logout'),
                          onTap: () => Provider.of<UserNotifier>(context, listen: false).signOut(),
                        )
                      ]
                    ),
                  ),
                );
              }
            );
          },
        ),
      ],
    );
  }
}