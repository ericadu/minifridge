import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String pushToken;

  User({
    this.id,
    this.pushToken,
  });

  User.fromSnaphot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.pushToken = snapshot['pushToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pushToken'] = this.pushToken;
    return data;
  }
}