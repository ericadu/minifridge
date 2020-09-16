import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:quiver/strings.dart';


class SingleItemNotifier extends ChangeNotifier {
  FoodBaseApi _api;
  BaseItem _item;
  
  SingleItemNotifier(FoodBaseApi api, BaseItem item) {
    _api = api;
    _item = item;
  }

  BaseItem get item => _item;
  int get quantity => _item.quantity;


  void updateItem({String newDate,
    String newName,
    String newCategory,
    String newReference,
    String newEndDate
  }) async {
    // if (isNotEmpty(newName)) {
    //   _item.setNewName(newName);
    // }

    // if (isNotEmpty(newReference)) {
    //   _item.setNewReference(DateFormat.yMMMEd().parse(newReference));
    // }

    // if (_item.shelfLife.perishable) {
    //   DateTime rangeStart = isNotEmpty(newDate) ? DateFormat.yMMMEd().parse(newDate) : _item.rangeStartDate;
    //   DateTime rangeEnd = isNotEmpty(newEndDate) ? DateFormat.yMMMEd().parse(newEndDate) : null;

    //   _item.setNewShelfLife(rangeStart, rangeEnd);
    // }

    // if (isNotEmpty(newCategory)) {
    //   _item.setNewCategory(newCategory);
    // }
    
    update();
  }

  void update() async {
    Map data = _item.toJson();
    notifyListeners();
    return await _api.updateBaseItem(_item.id, data);
  }
}