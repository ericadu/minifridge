import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/services/user_items_api.dart';

class SingleItemNotifier extends ChangeNotifier {
  // UserItemsApi _api;
  FoodBaseApi _api;
  BaseItem _item;
  
  SingleItemNotifier(FoodBaseApi api, BaseItem item) {
    _api = api;
    _item = item;
  }

  BaseItem get item => _item;
  int get quantity => _item.quantity;

  // Timestamp get expTimestamp => _item.expTimestamp;

  void decrement() async {
    _item.decrement();
    analytics.logEvent(
      name: 'edit_item', 
      parameters: {'item': _item.displayName, 'type': 'decrease'});
    update();
  }

  void increment() async {
    _item.increment();
    analytics.logEvent(
      name: 'edit_item', 
      parameters: {'item': _item.displayName, 'type': 'increase'});
    update();
  }

  void updateRef(Timestamp expTime) async {
    _item.setNewReference(expTime);
    analytics.logEvent(
      name: 'edit_item', 
      parameters: {'item': _item.displayName, 'type': 'reference'});
    update();
  }

  void update() async {
    Map data = _item.toJson();
    notifyListeners();
    return await _api.updateDocument(_item.id, data);
  }
}