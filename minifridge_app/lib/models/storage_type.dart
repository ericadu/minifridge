import 'package:meta/meta.dart';

class StorageType {
  String id;
  String location;
  String temp;

  StorageType({
    this.id,
    @required this.location,
    @required this.temp
  });

  StorageType.fromMap(Map data) {
    this.location = data['location'];
    this.temp = data['temp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['temp'] = this.temp;
    return data;
  }
}