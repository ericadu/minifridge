import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionsApi {
  CollectionReference _collectionReference;

  CollectionsApi(CollectionReference collectionReference) {
    _collectionReference = collectionReference;
  }

  Stream<QuerySnapshot> streamCollection() {
    return _collectionReference.snapshots();
  }

  Future<QuerySnapshot> getCollection() {
    return _collectionReference.getDocuments();
  }

  Future<DocumentReference> addDocument(Map data) {
    return _collectionReference.add(data);
  }
}