import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/screens/base_items/categories/categorized_items.dart';
import 'package:minifridge_app/screens/base_items/categories/category_header.dart';
import 'package:minifridge_app/screens/base_items/empty_base.dart';
import 'package:minifridge_app/providers/base_notifier.dart';
import 'package:minifridge_app/screens/base_items/tile/slidable_tile.dart';
import 'package:minifridge_app/screens/home/tabbed_search_app_bar.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/widgets/add_item_button.dart';
import 'package:provider/provider.dart';

class BaseItemsPage extends StatelessWidget {
  final FoodBaseApi api;
  static const routeName = '/items';

  const BaseItemsPage({Key key, this.api}) : super(key: key);

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
          
          // TODO: refactor a messy sort function.
          foods.sort((a, b) {
            if (a.shelfLife.perishable && b.shelfLife.perishable) {
              int comparison = -(a.getFreshness().index.compareTo(b.getFreshness().index));
              if (comparison == 0) {
                return a.getDays().compareTo(b.getDays());
              }
              return comparison;
            } else {
              if (a.shelfLife.perishable) {
                return -1;
              }

              if (b.shelfLife.perishable) {
                return 1;
              }

              return a.displayName.compareTo(b.displayName);
            }
          });
          
          if (foods.isNotEmpty) {
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