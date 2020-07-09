import 'package:cloud_firestore/cloud_firestore.dart';

class SignedInUser {
  String id;
  String email;
  String pushToken;
  String baseId;

  SignedInUser({
    this.id,
    this.email,
    this.pushToken,
    this.baseId,
  });

  SignedInUser.fromSnaphot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.email = snapshot['emil'];
    this.pushToken = snapshot['pushToken'];
    this.baseId = snapshot['baseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['pushToken'] = this.pushToken;
    data['baseId'] = this.baseId;
    return data;
  }
}