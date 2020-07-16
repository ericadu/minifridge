import 'package:flutter/material.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsMenu extends StatelessWidget {
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, AuthNotifier user, _) {
        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
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
                  onTap: () {
                    user.signOut();
                    Navigator.pop(context);
                  }
                )
              ]
            ),
          ),
        );
      });
  }
}