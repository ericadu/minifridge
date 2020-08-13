import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/screens/base_items/categories/categorized_groups.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:minifridge_app/screens/base_items/empty_base.dart';
import 'package:minifridge_app/providers/base_notifier.dart';
import 'package:minifridge_app/screens/home/tabbed_search_app_bar.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/widgets/add_item_button.dart';
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
  final List<List<Category>> _categories = [ perishables, categories ];
  final List<ViewTab> _tabs = [
    ViewTab(title: 'By Expiration'), ViewTab(title: 'By Category')
  ];
  final List<Function> groupBys = [
    groupByPerishable,
    groupByCategory
  ];

  final List<ItemScrollController> _scrollControllers = categories.map((category) {
    return new ItemScrollController();
  }).toList();

  final List<ItemPositionsListener> positionsListeners = categories.map((category) {
    return ItemPositionsListener.create();
  }).toList();

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
                  TabbedSearchAppBar(
                    controller: _controller,
                    tabs: _tabs,
                    categories: _currentCategorization,
                    scrollControllers: _scrollControllers
                  )
                ];
              },
              body: TabBarView(
                controller: _controller,
                children: Iterable<int>.generate(_tabs.length).toList().map((idx) {
                  return CategorizedGroups(
                    foods: foods,
                    categories: _categories[idx],
                    groupBy: groupBys[idx],
                    scrollController: _scrollControllers[idx],
                    positionsListener: positionsListeners[idx],
                  );
                }).toList()
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