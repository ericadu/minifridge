import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreApi {
  final _firestore = Firestore.instance;
  CollectionReference _collectionReference;

  FirestoreApi(String collectionPath) {
    _collectionReference = _firestore.collection(collectionPath);
  }
}