import 'dart:math' as math;
import 'package:flutter/material.dart';

List<String> categories = [
  'Dairy & Alternatives',
  'Proteins',
  'Grains',
  'Fruits',
  'Vegetables',
  'Snacks & Sweets',
  'Sauces & Spreads',
  'Beverages',
  'Alcohol',
  'Supplements',
  'Prepared meals',
  'Misc',
  'Uncategorized'
];

class CategoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: StickyRowDelegate(
        collapsedHeight: 80.0,
        expandedHeight: 80.0,
        child: Container(
          padding: EdgeInsets.only(top: 30, left: 15, right: 15),
          color: Colors.white,
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(categories[index]);
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