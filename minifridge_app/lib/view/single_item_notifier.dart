import 'package:cloud_firestore/cloud_firestore.dart';
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

  UserItem get item => _item;
  int get quantity => _item.quantity;

  Timestamp get expTimestamp => _item.expTimestamp;

  void decrement() async {
    _item.decrement();
    update();
  }

  void increment() async {
    _item.increment();
    update();
  }

  void updateExp(Timestamp expTime) async {
    _item.setNewExp(expTime);
    update();
  }

  void update() async {
    Map data = _item.toJson();
    notifyListeners();
    return await _api.updateDocument(_item.id, data);
  }
}