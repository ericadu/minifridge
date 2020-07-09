import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/services/user_items_api.dart';

class BaseItemsNotifier extends ChangeNotifier {
  UserItemsApi _api;
  List<BaseItem> _userItems;
  
  BaseItemsNotifier(UserItemsApi api) {
    _api = api;
  }

  Future<List<BaseItem>> getItems() async {
    QuerySnapshot result = await _api.getCollection();
    _userItems = result.documents
        .map((document) => BaseItem.fromMap(document.data, document.documentID))
        .toList();

    return _userItems;
  }

  Stream<QuerySnapshot> streamUserItems() {
    return _api.streamCollection();
  }

  void toggleEaten(BaseItem item) async {
    item.eat();
    Map data = item.toJson();
    return await _api.updateDocument(item.id, data);
  }
}