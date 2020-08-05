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


  void updateItem({String newDate, String newName, String newReference}) async {
    if (newName != null) {
      _item.setNewName(newName);
    }

    if (newDate != null) {
      _item.setNewRangeStart(DateFormat.yMMMEd().parse(newDate));
    }

    if (newReference != null) {
      _item.setNewReference(DateFormat.yMMMEd().parse(newReference));
    }

    update();
  }

  void update() async {
    Map data = _item.toJson();
    notifyListeners();
    return await _api.updateBaseItem(_item.id, data);
  }
}