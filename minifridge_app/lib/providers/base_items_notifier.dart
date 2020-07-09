import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/food_base_api.dart';

class BaseItemsNotifier extends ChangeNotifier {
  FoodBaseApi _api;
  
  BaseItemsNotifier(FoodBaseApi api) {
    _api = api;
  }

  Stream<QuerySnapshot> streamUserItems() {
    return _api.streamCollection();
  }

  Stream<QuerySnapshot> streamItems() {
    return _api.streamCollection();
  }

  Future<DocumentReference> addNewItem(Map data) {
    return _api.addDocument(data);
  }

  void toggleEaten(BaseItem item) async {
    item.eat();
    Map data = item.toJson();
    return await _api.updateDocument(item.id, data);
  }
}