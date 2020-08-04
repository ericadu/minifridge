import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/screens/base_items/base_item_tile.dart';
import 'package:minifridge_app/screens/base_items/empty_base.dart';
import 'package:minifridge_app/screens/base_items/home_app_bar.dart';
import 'package:minifridge_app/providers/base_items_notifier.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:provider/provider.dart';

class BaseItemsPage extends StatelessWidget {
  final FoodBaseApi api;
  static const routeName = '/items';

  const BaseItemsPage({Key key, this.api}) : super(key: key);

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Text(
              " Eat",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Trash",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  bool _validItem(BaseItem item) {
    return item.endType == EndType.alive && item.quantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    // SignedInUser user = Provider.of<AuthNotifier>(context, listen: false).signedInUser;
    // final FoodBaseApi _baseApi = FoodBaseApi(user.baseId);

    return Consumer(
      builder: (BuildContext context, BaseItemsNotifier baseItems, _) {
        return StreamBuilder(
          stream: baseItems.streamItems(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.documents.length > 0) {
              List<BaseItem> foods = snapshot.data.documents
                .map((item) => BaseItem.fromMap(item.data, item.documentID))
                .where((item) => _validItem(item))
                .toList();
              
              // TODO: refactor a messy sort function.
              foods.sort((a, b) {
                if (a.perishable && b.perishable) {
                  int comparison = -(a.getFreshness().index.compareTo(b.getFreshness().index));
                  if (comparison == 0) {
                    return a.getDays().compareTo(b.getDays());
                  }
                  return comparison;
                } else {
                  if (a.perishable) {
                    return -1;
                  }

                  if (b.perishable) {
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
                        EndType endtype;
                        return Dismissible(
                          background: slideRightBackground(),
                          secondaryBackground: slideLeftBackground(),
                          key: Key(item.id),
                          onDismissed: (DismissDirection direction) {
                            if (direction == DismissDirection.startToEnd) {
                              baseItems.updateEndtype(item, EndType.thrown);
                              endtype = EndType.thrown;
                            } else if (direction == DismissDirection.endToStart) {
                              baseItems.updateEndtype(item, EndType.eaten);
                              endtype = EndType.eaten;
                            }

                            analytics.logEvent(
                              name: 'remove_item', 
                              parameters: {
                                'item': item.displayName,
                                'type': describeEnum(endtype),
                                'user': Provider.of<AuthNotifier>(context, listen:false).user.uid,
                              });
  
                            Scaffold
                              .of(context)
                              .showSnackBar(
                                SnackBar(
                                  content: Text("${item.displayName} ${describeEnum(endtype)}"),
                                  action: SnackBarAction(
                                    label: "Undo",
                                    textColor: Colors.yellow,
                                    onPressed: () {
                                      baseItems.updateEndtype(item, EndType.alive);
                                    }
                                  )
                                )
                              );
                          },
                          child: BaseItemTile(item: item, api: api)
                        );
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