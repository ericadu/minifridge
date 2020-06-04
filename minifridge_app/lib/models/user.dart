import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minifridge_app/models/user_item.dart';

class User {
  String id;
  List<UserItem> currentItems;
  List<UserItem> itemHistory;

  User({
    this.id,
    this.currentItems,
    this.itemHistory
  });

  User.fromSnaphot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.currentItems = List.from(snapshot['currentItems']).map((x) => UserItem.fromMap(x));
    this.itemHistory = List.from(snapshot['itemHistory']).map((x) => UserItem.fromMap(x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currentItems'] = this.currentItems.map((x) => x.toJson());
    data['itemHistory'] = this.itemHistory.map((x) => x.toJson());
    return data;
  }
}