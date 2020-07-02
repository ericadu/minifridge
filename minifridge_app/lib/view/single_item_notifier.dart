import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/services/user_items_api.dart';

class SingleItemNotifier extends ChangeNotifier {
  UserItemsApi _api;
  UserItem _item;
  
  SingleItemNotifier(UserItemsApi api, UserItem item) {
    _api = api;
    _item = item;
  }

  int get quantity => _item.quantity;

  void decrement() async {
    _item.decrement();
    Map data = _item.toJson();
    notifyListeners();
    return await _api.updateDocument(_item.id, data);
  }

  void increment() async {
    _item.increment();
    Map data = _item.toJson();
    notifyListeners();
    return await _api.updateDocument(_item.id, data);
  }
}