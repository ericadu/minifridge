import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/models/shelf_life.dart';

enum EndType {
  eaten, thrown, alive
}

class BaseItem {
  String id;
  String displayName;
  int quantity;
  String unit;
  Timestamp buyTimestamp;
  String state;
  String storageType;
  String productId;
  EndType endType;
  ShelfLife shelfLife;
  Timestamp referenceTimestamp;
  String addedByUserId;

  BaseItem({
    this.id,
    this.displayName,
    @required this.quantity,
    @required this.unit,
    @required this.buyTimestamp,
    @required this.referenceTimestamp,
    @required this.addedByUserId,
    this.productId,
    this.state,
    this.storageType,
    this.shelfLife,
    this.endType,
  });

  BaseItem.fromMap(Map data, String docId) {
    this.id = docId;
    this.displayName = data['displayName'];
    this.quantity = data['quantity'];
    this.unit = data['unit'];
    this.buyTimestamp = data['buyTimestamp'];
    this.referenceTimestamp = data['referenceTimestamp'] ? data['referenceTimestamp'] : data['buyTimestamp'];
    this.state = data['state'];
    this.storageType = data['storageType'];
    this.productId = data['productId'];
    this.shelfLife = ShelfLife.fromMap(data['shelfLife']);
    this.endType = data['endType'] ? EndTypes.from(data['endType']): EndType.alive;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['buyTimestamp'] = this.buyTimestamp;
    data['refTimestamp'] = this.referenceTimestamp;
    data['state'] = this.state;
    data['storageType'] = this.storageType;
    data['productId'] = this.productId;
    data['shelfLife'] = this.shelfLife.toJson();
    data['endType'] = describeEnum(this.endType);
    return data;
  }

  void end(EndType endType) {
    this.endType = endType;
  }

  void decrement() {
    this.quantity = this.quantity - 1;
  }

  void increment() {
    this.quantity = this.quantity + 1;
  }

  // void setNewExp(Timestamp expTime) {
  //   this.expTimestamp = expTime;
  // }

  void setNewReference(Timestamp refTime) {
    this.referenceTimestamp = refTime;
  }

  DateTime referenceDatetime() {
    return DateTime.fromMicrosecondsSinceEpoch(referenceTimestamp.microsecondsSinceEpoch);
  }

  DateTime rangeStartDate() {
    return referenceDatetime().add(shelfLife.dayRangeStart);
  }

  DateTime rangeEndDate() {
    return referenceDatetime().add(shelfLife.dayRangeEnd);
  }

  
}