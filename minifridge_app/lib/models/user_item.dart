import 'package:meta/meta.dart';
import 'package:minifridge_app/models/produce_item.dart';
import 'package:minifridge_app/models/storage_type.dart';

class UserItem {
  String id;
  int quantity;
  String unit;
  int buyTimestamp;
  String state;
  int expTimestamp;
  StorageType storageType;
  ProduceItem produceItem;

  UserItem({
    this.id,
    @required this.quantity,
    @required this.unit,
    @required this.buyTimestamp,
    this.state,
    this.expTimestamp,
    this.storageType,
    this.produceItem
  });

  UserItem.fromMap(Map data) {
    this.quantity = data['quantity'];
    this.unit = data['unit'];
    this.buyTimestamp = data['buyTimestamp'];
    this.state = data['state'];
    this.expTimestamp = data['expTimestamp'];
    this.storageType = StorageType.fromMap(data['storageType']);
    this.produceItem = ProduceItem.fromMap(data['produceItem']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['buyTimestamp'] = this.buyTimestamp;
    data['state'] = this.state;
    data['expTimestamp'] = this.expTimestamp;
    data['storageType'] = this.storageType.toJson();
    data['produceItem'] = this.produceItem.toJson();
    return data;
  }
}