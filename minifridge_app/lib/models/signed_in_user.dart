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

  SignedInUser.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.email = snapshot.data['email'];
    this.pushToken = snapshot.data['pushToken'];
    this.baseId = snapshot.data['baseId'];
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