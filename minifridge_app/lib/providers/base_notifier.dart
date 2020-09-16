import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/models/signed_in_user.dart';
import 'package:minifridge_app/services/food_base_api.dart';

class BaseNotifier extends ChangeNotifier {
  FoodBaseApi _api;
  List<BaseItem> _baseItems;
  String _baseId;
  String _userId;
  
  BaseNotifier(SignedInUser user) {
    _api = FoodBaseApi(user.baseId);
    _baseId = user.baseId;
    _userId = user.id;
  }

  FoodBaseApi get api => _api;
  String get baseId => _baseId;
  String get userId => _userId;

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
    return _api.addItemToBase(data);
  }

  void updateEndtype(BaseItem item, EndType endType) async {
    item.end = endType;
    Map data = item.toJson();
    return await _api.updateBaseItem(item.id, data);
  }
}