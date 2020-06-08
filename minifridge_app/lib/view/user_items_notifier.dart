import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/services/user_item_api.dart';

class UserItemsNotifier extends ChangeNotifier {
  UserItemsApi _api;
  List<UserItem> _userItems;
  
  UserItemsNotifier(UserItemsApi api) {
    _api = api;
  }

  Future<List<UserItem>> getItems() async {
    QuerySnapshot result = await _api.getCollection();
    _userItems = result.documents
        .map((document) => UserItem.fromMap(document.data))
        .toList();
    return _userItems;
  }

  Stream<QuerySnapshot> streamUserItems() {
    return _api.streamCollection();
  }
}