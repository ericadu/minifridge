import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/theme.dart';

class CategoryHeader extends StatelessWidget {
  final List<Category> categories;

  CategoryHeader({
    this.categories
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: StickyRowDelegate(
        collapsedHeight: 110.0,
        expandedHeight: 110.0,
        child: Container(
          // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          color: Colors.white,
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
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 3, color: AppTheme.themeColor)
                  )
                )
              );
            }
          )
        )
      )
    );
  }
}

class StickyRowDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double expandedHeight;
  final double collapsedHeight;

  StickyRowDelegate({
    @required this.child,
    @required this.expandedHeight,
    @required this.collapsedHeight
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => math.max(expandedHeight, collapsedHeight);

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(StickyRowDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
           collapsedHeight != oldDelegate.collapsedHeight ||
           child != oldDelegate.child;
  }
}