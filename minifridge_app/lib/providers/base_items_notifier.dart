import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/food_base_api.dart';

class BaseItemsNotifier extends ChangeNotifier {
  FoodBaseApi _api;
  List<BaseItem> _baseItems;
  
  BaseItemsNotifier(FoodBaseApi api) {
    _api = api;
  }

  Future<List<BaseItem>> getItems() async {
    QuerySnapshot result = await _api.getCollection();
    _baseItems = result.documents
      .map((document) => BaseItem.fromMap(document.data, document.documentID))
      .toList();
    
    return _baseItems;
  }

  Stream<QuerySnapshot> streamItems() {
    return _api.streamCollection();
  }

  Future<DocumentReference> addNewItem(Map data) {
    return _api.addDocument(data);
  }

  void updateEndtype(BaseItem item, EndType endType) async {
    item.setEnd(endType);
    analytics.logEvent(
      name: 'remove_item', 
      parameters: {
        'item': item.displayName,
        'type': describeEnum(endType)
      });
    Map data = item.toJson();
    // notifyListeners();
    return await _api.updateDocument(item.id, data);
  }
}