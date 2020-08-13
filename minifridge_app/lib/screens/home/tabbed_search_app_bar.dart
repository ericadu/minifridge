import 'package:flutter/material.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/base_items.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/settings_menu.dart';

class TabbedSearchAppBar extends StatelessWidget {
  final TabController controller;
  final List<ViewTab> tabs;
  List<Category> categories;

  TabbedSearchAppBar({this.controller, this.tabs, this.categories});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // expandedHeight: 50,
      floating: true,
      pinned: true,
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
      title: TabBar(
        tabs: tabs.map((tab) => Tab(text: tab.title)).toList(),
        controller: controller
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Container(
          // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              Category category = categories[index];

              return Container(
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Text(category.image,
                        style: TextStyle(fontSize: 45)
                      )
                    ),
                    Text(category.name,
                      style: TextStyle(fontSize: 8)
                    )
                  ],
                ),
              );
            }
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 3, color: AppTheme.themeColor)
            )
          )
        )
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