import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class UserItem {
  String displayName;
  String id;
  int quantity;
  String unit;
  Timestamp buyTimestamp;
  String state;
  Timestamp expTimestamp;
  String storageType;
  DocumentReference produceItem;
  bool eaten;

  UserItem({
    this.id,
    this.displayName,
    @required this.quantity,
    @required this.unit,
    @required this.buyTimestamp,
    this.state,
    this.expTimestamp,
    this.storageType,
    this.produceItem,
    this.eaten
  });

  UserItem.fromMap(Map data, String docId) {
    this.id = docId;
    this.displayName = data['displayName'];
    this.quantity = data['quantity'];
    this.unit = data['unit'];
    this.buyTimestamp = data['buyTimestamp'];
    this.state = data['state'];
    this.expTimestamp = data['expTimestamp'];
    this.storageType = data['storageType'];
    this.produceItem = data['produceItem'];
    this.eaten = data['eaten'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['buyTimestamp'] = this.buyTimestamp;
    data['state'] = this.state;
    data['expTimestamp'] = this.expTimestamp;
    data['storageType'] = this.storageType;
    data['produceItem'] = this.produceItem;
    data['eaten'] = this.eaten;
    return data;
  }

  void eat() {
    this.eaten = !this.eaten;
  }
}