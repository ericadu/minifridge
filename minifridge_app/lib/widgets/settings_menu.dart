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
          // color: Color(0xFF737373),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          //   boxShadow: [
          //     BoxShadow(
          //       blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
          //   ],
          // ),
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