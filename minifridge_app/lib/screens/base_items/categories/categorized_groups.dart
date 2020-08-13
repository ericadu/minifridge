import 'package:flutter/material.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:minifridge_app/screens/home/tabbed_search_app_bar.dart';

class CategorizedGroups extends StatefulWidget {
  @override
  _CategorizedGroupsState createState() => _CategorizedGroupsState();
}

class ViewTab {
  String title;
  String color;

  ViewTab(this.title, this.color);
}

class _CategorizedGroupsState extends State<CategorizedGroups> with TickerProviderStateMixin {
  List<List<Category>> _categories = [
    perishables, categories
  ];

  final List<ViewTab> _tabs = [
    ViewTab('By Expiration', 'By Category')
  ];

  TabController _controller;
  ViewTab _currentHandler;
  List<Category> _currentCategorization;

  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _currentHandler = _tabs[0];
    _currentCategorization = _categories[0];
    _controller.addListener(_handleSelected);
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSelected() {
    setState(() {
      _currentHandler = _tabs[_controller.index];
      _currentCategorization = _categories[_controller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    TabbedSearchAppBar()
                  ];
                },
                body: TabBarView(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.only(top: 0, bottom: 50),
                      itemCount: foods.length,
                      itemBuilder: (BuildContext context, int index) {
                        BaseItem item = foods[index];
                        return SlidableTile(item: item);
                      }
                    ),
                    CategorizedItems(foods: foods)
                  ],
                )
              )
            );
  }
}