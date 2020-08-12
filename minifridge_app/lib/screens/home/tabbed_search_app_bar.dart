import 'package:flutter/material.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/settings_menu.dart';

class TabbedSearchAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 50,
      floating: true,
      // pinned: true,
      snap: false,
      // flexibleSpace: FlexibleSpaceBar(
      //   titlePadding: EdgeInsets.symmetric(vertical: 20),
      //   title: Padding(
      //     padding: EdgeInsets.symmetric(vertical: 20),
      //     child: TextField(
      //       decoration: InputDecoration(
      //         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      //         border: OutlineInputBorder(
      //           borderRadius: BorderRadius.all(
      //             Radius.circular(10.0)
      //           )
      //         ),
      //         hintStyle: new TextStyle(color: Colors.grey),
      //         hintText: "Search foodbase",
      //       )
      //     ),
      //   ),
      // ),
      bottom: TabBar(
        tabs: [
          Tab(text: 'All'),
          Tab(text: 'By Category')
        ]
      ),
      // actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.menu, color: AppTheme.themeColor),
      //     onPressed: () {
      //       showModalBottomSheet(
      //         context: context,
      //         builder: (context) {
      //           return SettingsMenu();
      //         }
      //       );
      //     },
      //   ),
      // ],
    );
  }
}