import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:minifridge_app/models/shelf_life.dart';

class ProduceItem {
  String id;
  String name;
  String displayName;
  List<ShelfLife> shelfLifes;

  ProduceItem({
    this.id,
    @required this.name,
    this.displayName
  });

  ProduceItem.fromMap(Map snapshot) {
    this.name = snapshot["name"];
    this.displayName = snapshot["displayName"];
    this.shelfLifes = List.from(snapshot["shelf_lifes"]).map((x) => ShelfLife.fromMap(x));
  }

  ProduceItem.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.name = snapshot["name"];
    this.displayName = snapshot["displayName"];
    this.shelfLifes = List.from(snapshot["shelf_lifes"]).map((x) => ShelfLife.fromMap(x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['displayName'] = this.displayName;
    data['shelfLifes'] = this.shelfLifes.map((x) => x.toJson());
    return data;
  }
}