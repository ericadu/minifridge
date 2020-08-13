import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/category.dart';
import 'package:minifridge_app/screens/base_items/tile/slidable_tile.dart';

class CategorizedItems extends StatelessWidget {
  final Category category;
  final List<BaseItem> foods;

  CategorizedItems({
    this.category,
    this.foods
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [
      SizedBox(
        height: 80,
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Card(
            child: Container(
              
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(category.image, style: TextStyle(fontSize: 25))
                  ),
                  Text(category.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  )
                ]
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 2, color: Colors.grey[300])
                )
              )
            )
          )
        )
      )
    ];

    if (foods.length > 0) {
      foods.forEach((item) {
        slivers.add(SlidableTile(item: item));
      });
    }
    return Column(
      children: slivers
    );
  }
}

// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:minifridge_app/models/base_item.dart';
// import 'package:minifridge_app/models/category.dart';
// import 'package:minifridge_app/screens/base_items/categories/category_header.dart';
// import 'package:minifridge_app/screens/base_items/categories/constants.dart';
// import 'package:minifridge_app/screens/base_items/tile/slidable_tile.dart';
// import 'package:minifridge_app/theme.dart';



// class CategorizedItems extends StatelessWidget {
//   final List<BaseItem> foods;

//   CategorizedItems({
//     this.foods
//   });

//   Map<String, List<BaseItem>> _groupBy(List<BaseItem> foods) {
//     return groupBy(foods, (food) => food.category);
//   }

//   List<Widget> _buildSlivers() {
//     List<Widget> slivers = [
      
//     ];

//     Map<String, List<BaseItem>> foodsByCategory = _groupBy(foods);

//     categories.forEach((category) {

//       if (foodsByCategory.containsKey(category.name)) {
//         List<BaseItem> foodsInCategory = foodsByCategory[category.name];

//         slivers.add(
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: 80,
//               child: Padding(
//                 padding: EdgeInsets.only(top: 20),
//                 child: Card(
//                   child: Container(
                    
//                     padding: EdgeInsets.only(left: 20),
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(right: 10),
//                           child: Text(category.image, style: TextStyle(fontSize: 25))
//                         ),
//                         Text(category.name,
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
//                         )
//                       ]
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border(
//                         bottom: BorderSide(width: 2, color: Colors.grey[300])
//                       )
//                     )
//                   )
//                 )
//               )
//             )
//           )
//         );

//         slivers.add(
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 BaseItem item = foodsInCategory[index];
//                 return SlidableTile(item: item);
//               },
//               childCount: foodsInCategory.length
//             )
//           )
//         );
//       }

//     });

//     return slivers;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Map<String, List<BaseItem>> foodsByCategory = _groupBy(foods);

//     return CustomScrollView(
//       slivers: _buildSlivers()
//       // slivers: <Widget>[
//       //   CategoryHeader(categories: categories),
//       //   SliverList(
//       //     delegate: SliverChildBuilderDelegate(
//       //       (BuildContext context, int index) {
//       //         Category category = categories[index];
//       //         List<BaseItem> foodsInCategory = foodsByCategory[category.name];
//       //         // return Container(
//       //         //   child:  ListView.builder(
//       //         //     itemCount: foodsInCategory.length,
//       //         //     itemBuilder: (BuildContext context, int index) {
//       //         //       BaseItem item = foodsInCategory[index];
//       //         //       return SlidableTile(item: item);
//       //         //     }
//       //         //   )
//       //         // );
//       //         // return Container(
//       //         //   child: Text(category.name)
//       //         // );
//       //         // BaseItem item = foods[index];
//       //         // return SlidableTile(item: item);
//       //         // return NestedScrollView(
//       //         //   headerSliverBuilder: (context, value) {
//       //         //     return [
//       //         //       Text(category.name)
//       //         //     ];
//       //         //   },
//       //         //   body: ListView.builder(
//       //         //     itemCount: foodsInCategory.length,
//       //         //     itemBuilder: (BuildContext context, int index) {
//       //         //       BaseItem item = foodsInCategory[index];
//       //         //       return SlidableTile(item: item);
//       //         //     }
//       //         //   )
//       //         // );
//       //       },
//       //       childCount: categories.length
//       //     )
//       //   ),
//       // ]
//     );
//   }
// }