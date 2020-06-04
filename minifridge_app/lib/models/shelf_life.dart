import 'package:meta/meta.dart';
import 'package:minifridge_app/models/storage_type.dart';

class ShelfLife {
  String id;
  String state;
  double time;
  StorageType storageType;

  ShelfLife({
    this.id,
    @required this.state,
    @required this.time,
    @required this.storageType
  });

  ShelfLife.fromMap(Map data) {
    state = data['state'];
    time = data['time'];
    storageType = StorageType.fromMap(data['storageType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['time'] = this.time;
    data['storageType'] = this.storageType.toJson();
    return data;
  }
}