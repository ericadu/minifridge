import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentApi {
  DocumentReference _documentReference;

  DocumentApi(DocumentReference documentReference) {
    _documentReference = documentReference;
  }

  Future<void> update(Map data) {
    return _documentReference.updateData(data);
  }

  Stream<DocumentSnapshot> streamDocument() {
    return _documentReference.snapshots();
  }

  Future<DocumentSnapshot> getDocument() {
    return _documentReference.get();
  }
}