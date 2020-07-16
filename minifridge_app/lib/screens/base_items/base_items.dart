import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/models/signed_in_user.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/screens/base_items/base_item_tile.dart';
import 'package:minifridge_app/screens/base_items/home_app_bar.dart';
import 'package:minifridge_app/providers/base_items_notifier.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:provider/provider.dart';

class BaseItemsPage extends StatelessWidget {
  static const routeName = '/items';

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

  Widget _buildEmpty() {
    return CustomScrollView(
      slivers: <Widget>[
        HomeAppBar(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text("🍩", style: TextStyle(fontSize: 50)),
                  ),
                  Text("You do-nut have any items!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 45, right: 20),
                    child: Text("📷  Upload a photo of your last grocery receipt to add food.",
                      style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 50),
                    child: Image.asset(
                      "images/arrow.png",
                      scale: 3.5,
                    )
                  )
                ]
              ),
            )
          )
        )
      ]
    );
  }

  bool _validItem(BaseItem item) {
    return item.endType == EndType.alive && item.quantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    SignedInUser user = Provider.of<AuthNotifier>(context, listen: false).signedInUser;
    final FoodBaseApi _baseApi = FoodBaseApi(user.baseId);

    return ChangeNotifierProvider(
      create: (_) => BaseItemsNotifier(_baseApi),
      child:  Consumer(
        builder: (BuildContext context, BaseItemsNotifier baseItems, _) {
          return StreamBuilder(
            stream: baseItems.streamItems(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data.documents.length > 0) {
                List<BaseItem> foods = snapshot.data.documents
                  .map((item) => BaseItem.fromMap(item.data, item.documentID))
                  .where((item) => _validItem(item))
                  .toList();
                
                foods.sort((a, b) {
                  return a.getDays().compareTo(b.getDays());
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
                            child: BaseItemTile(item: item, api: _baseApi)
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
              } else {
                return _buildEmpty();
              }
            }
          );
        }
      )
    );
  }
}