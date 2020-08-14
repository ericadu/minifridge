import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/screens/base_items/categories/categorized_groups.dart';
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
  final List<List<Category>> _categories = [ perishables, groupings ];
  final List<ViewTab> _tabs = [
    ViewTab(title: 'Expiring Soon'), ViewTab(title: 'All Items')
  ];
  final List<Function> groupBys = [
    groupByPerishable,
    groupByCategory
  ];

  final List<ItemScrollController> _scrollControllers = groupings.map((category) {
    return new ItemScrollController();
  }).toList();

  final List<ItemPositionsListener> positionsListeners = groupings.map((category) {
    return ItemPositionsListener.create();
  }).toList();

  int selectedCategory = 0;

  TabController _controller;
  List<Category> _currentCategorization = perishables;

  void initState() {
    super.initState();
    _controller = new TabController(length: _tabs.length, vsync: this);
    _currentCategorization = _categories[0];
    _controller.addListener(_handleSelected);
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSelected() {
    setState(() {
      _currentCategorization = _categories[_controller.index];
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
            List<Category> categories = _currentCategorization;
            return NestedScrollView(
              headerSliverBuilder: (context, value) {
                Widget horizCat = PreferredSize(preferredSize: Size.fromHeight(72),
                  child: Container(
                        // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        color: Colors.white,
                        height: 72,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            Category category = categories[index];
                            
                            // int  min = positionsListeners[1].itemPositions.value
                            //   .where((ItemPosition position) => position.itemTrailingEdge > 0)
                            //   .reduce((ItemPosition min, ItemPosition position) =>
                            //       position.itemTrailingEdge < min.itemTrailingEdge
                            //           ? position
                            //           : min)
                            //   .index;

                            Color isSelected = index == selectedCategory ? AppTheme.lightTheme.accentColor : Colors.grey[300];

                            return InkWell(
                              onTap: () {
                                _handleCategorySelect(index);
                                _scrollControllers[_controller.index].scrollTo(
                                  index: index,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeInOutCubic
                                );
                                // .then((event) {
                                //   print(positionsListeners[1].itemPositions.value.first.index);
                                // });
                                
                              },
                              child: Container(
                                width: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10, bottom: 2),
                                      child: Text(category.image,
                                        style: TextStyle(fontSize: 32)
                                      )
                                    ),
                                    Text(category.name,
                                      style: TextStyle(fontSize: 8, color: isSelected)
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(width: 2, color: isSelected)
                                  )
                                )
                              ),
                              
                            );
                          }
                        ),
                      ));
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
                      if (_controller.index == 1)
                        horizCat
                   ],
                    height: _controller.index == 1 ? 120 : 48
                  )
                ];
              },
              body: TabBarView(
                controller: _controller,
                // children: Iterable<int>.generate(_tabs.length).toList().map((idx) {
                //   return CategorizedGroups(
                //     foods: foods,
                //     categories: _categories[idx],
                //     groupBy: groupBys[idx],
                //     scrollController: _scrollControllers[idx],
                //     positionsListener: positionsListeners[idx],
                //   );
                // }).toList()
                children:  [
                  BaseItemsList(foods: foods.where((item) => item.shelfLife.perishable).toList()),
                  CategorizedGroups(
                    foods: foods,
                    categories: _categories[1],
                    groupBy: groupBys[1],
                    scrollController: _scrollControllers[1],
                    positionsListener: positionsListeners[1],
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
                  child: CircularProgressIndicator(),
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