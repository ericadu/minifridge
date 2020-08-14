import 'package:flutter/material.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:minifridge_app/theme.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategoryHeader extends StatelessWidget {
  final int selectedCategory;
  final Function handleCategorySelect;
  final ItemScrollController scrollController;

  CategoryHeader({
    this.selectedCategory,
    this.handleCategorySelect,
    this.scrollController
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(preferredSize: Size.fromHeight(72),
      child: Container(
        color: Colors.white,
        height: 72,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: groupings.length,
          itemBuilder: (BuildContext context, int index) {
            Category category = groupings[index];
            
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
                handleCategorySelect(index);
                scrollController.scrollTo(
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
  }
}