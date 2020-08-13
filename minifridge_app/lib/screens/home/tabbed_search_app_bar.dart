import 'package:flutter/material.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/base_items.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/settings_menu.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TabbedSearchAppBar extends StatelessWidget {
  final TabController controller;
  final List<ViewTab> tabs;
  final List<ItemScrollController> scrollControllers;
  final List<Category> categories;

  TabbedSearchAppBar({
    this.controller,
    this.tabs,
    this.categories,
    this.scrollControllers
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      title: TabBar(
        tabs: tabs.map((tab) => Tab(text: tab.title)).toList(),
        controller: controller
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              Category category = categories[index];

              return InkWell(
                onTap: () {
                  scrollControllers[controller.index].scrollTo(
                    index: index,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOutCubic
                  );
                },
                child: Container(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Text(category.image,
                          style: TextStyle(fontSize: 35)
                        )
                      ),
                      Text(category.name,
                        style: TextStyle(fontSize: 8)
                      )
                    ],
                  ),
                )
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