import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/services/user_item_api.dart';

class UserItemsNotifier extends ChangeNotifier {
  UserItemsApi _api;
  List<UserItem> _userItems;
  
  UserItemsNotifier(UserItemsApi api) {
    _api = api;
  }
}