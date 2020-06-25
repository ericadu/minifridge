import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreApi {
  final _firestore = Firestore.instance;
  CollectionReference _collectionReference;

  FirestoreApi(String collectionPath) {
    _collectionReference = _firestore.collection(collectionPath);
  }

  FirestoreApi.fromSubcollection(String collectionPath, String docId, String subcollectionPath) {
    _collectionReference = _firestore.collection(collectionPath).document(docId).collection(subcollectionPath);
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

  Future<void> updateDocument(String id, Map data) {
    return _collectionReference.document(id).updateData(data);
  }
}