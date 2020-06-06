import 'package:meta/meta.dart';

class ShelfLife {
  String id;
  String state;
  double time;
  String storageType;

  ShelfLife({
    this.id,
    @required this.state,
    @required this.time,
    @required this.storageType
  });

  ShelfLife.fromMap(Map data) {
    state = data['state'];
    time = data['time'];
    storageType = data['storageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['time'] = this.time;
    data['storageType'] = this.storageType;
    return data;
  }
}