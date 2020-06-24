import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:minifridge_app/view/user_notifier.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';

    void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(10),
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
        )
      )
    );
  }
}