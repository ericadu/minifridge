import 'dart:math' as math;
import 'package:flutter/material.dart';

class TabbedCategoriesBar extends StatelessWidget {
  final List<Widget> widgets;
  final double height;

  TabbedCategoriesBar({
    this.widgets,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: StickyRowDelegate(
        collapsedHeight: height,
        expandedHeight: height,
        child: Container(
          color: Colors.white,
          height: height,
          child: Column(
            children: widgets
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