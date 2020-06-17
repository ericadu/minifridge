import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:minifridge_app/view/user_notifier.dart';

class HomeDrawer extends StatelessWidget {
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer')
          ),
          ListTile(
            title: Text("🍑  What's in season?"),
            onTap: () {
              launchURL("https://www.seasonalfoodguide.org");
            }
          ),
          ListTile(
            title: Text('⚙️  Settings - Coming Soon'),
            onTap: () {
              Navigator.pop(context);
            }
          ),
          ListTile(
            title: Text('👋  Logout'),
            onTap: () => Provider.of<UserNotifier>(context, listen: false).signOut(),
          )
        ]
      )
    );
  }
}