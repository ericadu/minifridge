import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minifridge_app/models/base_item.dart';

class FoodBase {
  String id;
  String nickname;
  List<BaseItem> items;
  List<String> memberIds;
  String ownerId;

  FoodBase({
    this.id,
    this.nickname,
    this.items,
    this.memberIds,
    this.ownerId
  });

  FoodBase.fromSnaphot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.nickname = snapshot['nickname'];
    this.items = List.from(snapshot['items']).map((x) => BaseItem.fromMap(x, x['id']));
    this.memberIds = List.from(snapshot['memberIds']);
    this.ownerId = snapshot['ownerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['items'] = this.items.map((x) => x.toJson());
    data['memberIds'] = this.memberIds;
    data['ownerId'] = this.ownerId;
    return data;
  }
}