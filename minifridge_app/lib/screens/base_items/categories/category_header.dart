import 'dart:math' as math;
import 'package:flutter/material.dart';

List<String> categories = [
  'Proteins',
  'Grains',
  'Fruits',
  'Vegetables',
  'Dairy & Substitutes',
  'Snacks & Sweets',
  'Sauces & Spreads',
  'Beverages',
  'Alcohol',
  'Supplements',
  'Prepared meals',
  'Misc',
  'Uncategorized'
];

List<String> emoji = [
  '🍖',
  '🍞',
  '🍓',
  '🥬',
  '🧀',
  '🍿',
  '🍯',
  '🧃',
  '🍺',
  '💊',
  '🍱',
  '🥡',
  '🏷️'
];

class CategoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: StickyRowDelegate(
        collapsedHeight: 110.0,
        expandedHeight: 110.0,
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          color: Colors.white,
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                      child: Text(emoji[index],
                        style: TextStyle(fontSize: 45)
                      )
                    ),
                    Text(categories[index],
                      style: TextStyle(fontSize: 8)
                    )
                  ],
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