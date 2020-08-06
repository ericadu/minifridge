import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/screens/base_items/empty_base.dart';
import 'package:minifridge_app/screens/base_items/home_app_bar.dart';
import 'package:minifridge_app/providers/base_notifier.dart';
import 'package:minifridge_app/screens/base_items/slidable_tile.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:provider/provider.dart';

class BaseItemsPage extends StatelessWidget {
  final FoodBaseApi api;
  static const routeName = '/items';

  const BaseItemsPage({Key key, this.api}) : super(key: key);

  bool _validItem(BaseItem item) {
    return item.endType == EndType.alive && item.quantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, BaseNotifier base, _) {
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

              return CustomScrollView(
                slivers: <Widget>[
                  HomeAppBar(),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        BaseItem item = foods[index];
                        return SlidableTile(item: item);
                      },
                      childCount: foods.length
                    )
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 50),
                  ),
                ]
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomScrollView(
                slivers: <Widget>[
                  HomeAppBar(),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 450,
                      child: CircularProgressIndicator(),
                    )
                  )
                ]
              );
            } else {
              return EmptyBase();
            }
          }
        );
      }
    );
  }
}