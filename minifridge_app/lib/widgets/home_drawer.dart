import 'package:flutter/material.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('More')
          ),
          ListTile(
            title: Text("🍑  What's in season?"),
            onTap: () {
              Navigator.pop(context);
            }
          ),
          ListTile(
            title: Text('👤  Profile'),
            onTap: () {
              Navigator.pop(context);
            }
          ),
          ListTile(
            title: Text('⚙️  Settings'),
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