import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/screens/base_items/categories/categorized_groups.dart';
import 'package:minifridge_app/screens/base_items/categories/category_header.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:minifridge_app/screens/base_items/categories/tabbed_categories_bar.dart';
import 'package:minifridge_app/screens/base_items/empty_base.dart';
import 'package:minifridge_app/providers/base_notifier.dart';
import 'package:minifridge_app/screens/base_items/expiring/base_items_list.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/add_item_button.dart';
import 'package:minifridge_app/widgets/settings_menu.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ViewTab {
  String title;
  String color;

  ViewTab({this.title, this.color});
}

class BaseItemsPage extends StatefulWidget {
  final FoodBaseApi api;
  static const routeName = '/items';

  const BaseItemsPage({Key key, this.api}) : super(key: key);

  @override
  _BaseItemsPageState createState() => _BaseItemsPageState();
}

class _BaseItemsPageState extends State<BaseItemsPage> with TickerProviderStateMixin{
  final List<ViewTab> _tabs = [
    ViewTab(title: 'Expiring Soon'), ViewTab(title: 'All Items')
  ];
  ItemScrollController _scrollController = new ItemScrollController();
  ItemPositionsListener _positionsListener = new ItemPositionsListener.create();
  int selectedCategory = 0;
  int currentTab = 0;
  TabController _controller;

  void initState() {
    super.initState();
    _controller = new TabController(length: _tabs.length, vsync: this);
    // _currentCategorization = _categories[0];
    _controller.addListener(_handleTabSelected);
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTabSelected() {
    setState(() {
      currentTab = _controller.index;
    });
  }

  void _handleCategorySelect(int idx) {
    setState(() {
      selectedCategory = idx;
    });
  }

  bool _validItem(BaseItem item) {
    return item.endType == EndType.alive && item.quantity > 0;
  }

  Widget _buildBody(BaseNotifier base) {
    return StreamBuilder(
      stream: base.streamItems(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.documents.length > 0) {
          List<BaseItem> foods = snapshot.data.documents
            .map((item) => BaseItem.fromMap(item.data, item.documentID))
            .where((item) => _validItem(item))
            .toList();
          
          if (foods.isNotEmpty) {
            return NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    pinned: false,
                    backgroundColor: AppTheme.themeColor,
                    title: Text('foodbase', style: TextStyle(color: Colors.white)),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SettingsMenu();
                            }
                          );
                        },
                      ),
                    ],
                  ),
                  TabbedCategoriesBar(
                   widgets: [
                     TabBar(
                        tabs: _tabs.map((tab) => Tab(text: tab.title)).toList(),
                        controller: _controller,
                        indicatorColor: AppTheme.themeColor
                      ),
                      if (currentTab == 1)
                        CategoryHeader(
                          selectedCategory: selectedCategory,
                          handleCategorySelect: _handleCategorySelect,
                          scrollController: _scrollController,
                        )
                   ],
                    height: currentTab == 1 ? 120 : 48
                  )
                ];
              },
              body: TabBarView(
                controller: _controller,
                children:  [
                  BaseItemsList(foods: foods.where((item) => item.shelfLife.perishable).toList()),
                  CategorizedGroups(
                    foods: foods,
                    categories: groupings,
                    groupBy: groupByCategory,
                    scrollController: _scrollController,
                    positionsListener: _positionsListener,
                    initialIndex: selectedCategory,
                  )
                ]
              )
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 450,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  ),
                )
              )
            ]
          );
        } 

        return EmptyBase();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, BaseNotifier base, _) {
        return Scaffold(
          body: _buildBody(base),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: AddItemButton(),
        );
      }
    );
  }
}
