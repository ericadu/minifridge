import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:minifridge_app/models/end_type.dart';
import 'package:minifridge_app/models/shelf_life.dart';
import 'package:quiver/strings.dart';

class BaseItem {
  String id;
  String addedByUserId;
  Timestamp buyTimestamp;
  String displayName;
  Timestamp endTimestamp;
  EndType endType;
  double price;
  String productId;
  int quantity;
  Timestamp referenceTimestamp;
  ShelfLife shelfLife;
  String state;
  String storageType;
  String unit;
  String category;

  BaseItem({
    this.id,
    @required this.addedByUserId,
    @required this.buyTimestamp,
    this.displayName,
    this.endTimestamp,
    this.endType,
    this.price,
    this.productId,
    this.quantity,
    this.referenceTimestamp,
    this.shelfLife,
    this.state,
    this.storageType,
    this.unit,
    this.category
  });

  BaseItem.fromMap(Map data, String docId) {
    this.id = docId;
    this.addedByUserId = data['addedByUserId'];
    this.buyTimestamp = data['buyTimestamp'];
    this.displayName = data['displayName'];
    this.endTimestamp = data['endTimestamp'];
    this.endType = isNotEmpty(data['endType']) ? EndTypes.from(data['endType']): EndType.alive;
    this.price = data['price'];
    this.productId = data['productId'];
    this.quantity = data['quantity'];
    this.referenceTimestamp = data['referenceTimestamp'];
    this.shelfLife = ShelfLife.fromMap(data['shelfLife']);
    this.state = data['state'];
    this.storageType = data['storageType'];
    this.unit = data['unit'];
    this.category = isNotEmpty(data['category']) ? data['category'] : 'Uncategorized';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    data['addedByUserId'] = this.addedByUserId;
    data['buyTimestamp'] = this.buyTimestamp;
    data['displayName'] = this.displayName;
    data['endType'] = describeEnum(this.endType);
    data['endTimestamp'] = this.endTimestamp;
    data['price'] = this.price;
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['referenceTimestamp'] = this.referenceTimestamp;
    data['shelfLife'] = this.shelfLife.toJson();
    data['state'] = this.state;
    data['storageType'] = this.storageType; 
    data['unit'] = this.unit;
    data['category'] = this.category;

    return data;
  }

  void setEnd(EndType endType) {
    this.endType = endType;
    this.endTimestamp = Timestamp.fromDate(DateTime.now());
  }

  void setNewReference(DateTime refTime) {
    this.referenceTimestamp = Timestamp.fromDate(refTime);
  }

  void setNewName(String name) {
    this.displayName = name;
  }

  void setNewRangeStart(DateTime newDate) {
    Duration newDuration = newDate.difference(referenceDatetime());
    if (shelfLife.dayRangeEnd != null) {
      int range = shelfLife.dayRangeEnd.inDays - shelfLife.dayRangeStart.inDays;
      Duration newRangeEnd = Duration(days: newDuration.inDays + range);
      shelfLife = ShelfLife(
        perishable: true,
        dayRangeStart: newDuration,
        dayRangeEnd: newRangeEnd
      );
    }

    shelfLife = ShelfLife(
      perishable: true,
      dayRangeStart: newDuration,
    );
  }

  void setNewShelfLife(DateTime rangeStart, DateTime rangeEnd) {
    Duration newRangeStartDuration = rangeStart.difference(referenceDatetime());
    Duration newRangeEndDuration = rangeEnd != null ? rangeEnd.difference(referenceDatetime()) : null;

    shelfLife = ShelfLife(
      perishable: true,
      dayRangeStart: newRangeStartDuration,
      dayRangeEnd: newRangeEndDuration
    );
  }

  DateTime buyDatetime() {
    return DateTime.fromMicrosecondsSinceEpoch(buyTimestamp.microsecondsSinceEpoch);
  } 

  DateTime referenceDatetime() {
    return DateTime.fromMicrosecondsSinceEpoch(referenceTimestamp.microsecondsSinceEpoch);
  }

  DateTime rangeStartDate() {
    return referenceDatetime().add(shelfLife.dayRangeStart);
  }

  bool hasRange() {
    return shelfLife.dayRangeEnd != null;
  }

  DateTime rangeEndDate() {
    return referenceDatetime().add(shelfLife.dayRangeEnd);
  }
}