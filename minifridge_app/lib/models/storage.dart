import 'package:meta/meta.dart';
import 'package:minifridge_app/models/shelf_life.dart';

class Storage {
  String id;
  String storageType;
  String state;
  ShelfLife shelfLife;

  Storage({
    this.id,
    @required this.state,
    @required this.storageType,
    @required this.shelfLife,
  });

  Storage.fromMap(Map data) {
    state = data['state'];
    storageType = data['storageType'];
    shelfLife = ShelfLife.fromMap(data['shelfLife']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['storageType'] = this.storageType;
    data['shelfLife'] = this.shelfLife.toJson();
    return data;
  }
}