import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/food_base_api.dart';

class SingleItemNotifier extends ChangeNotifier {
  FoodBaseApi _api;
  BaseItem _item;
  
  SingleItemNotifier(FoodBaseApi api, BaseItem item) {
    _api = api;
    _item = item;
  }

  BaseItem get item => _item;
  int get quantity => _item.quantity;


  void updateItem({String newDate, String newName, String newReference, String newEndDate}) async {
    if (newName.isNotEmpty) {
      _item.setNewName(newName);
    }

    if (newReference.isNotEmpty) {
      _item.setNewReference(DateFormat.yMMMEd().parse(newReference));
    }

    if (_item.shelfLife.perishable) {
      DateTime rangeStart = newDate.isNotEmpty ? DateFormat.yMMMEd().parse(newDate) : _item.rangeStartDate();
      DateTime rangeEnd = newEndDate.isNotEmpty ? DateFormat.yMMMEd().parse(newEndDate) : _item.rangeEndDate();

      _item.setNewShelfLife(rangeStart, rangeEnd);
    }
    
    update();
  }

  void update() async {
    Map data = _item.toJson();
    notifyListeners();
    return await _api.updateBaseItem(_item.id, data);
  }
}