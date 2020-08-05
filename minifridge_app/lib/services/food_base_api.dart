import 'package:cloud_firestore/cloud_firestore.dart';

class FoodBaseApi {
  static final String basesReference = "bases";
  static final String itemsReference = "items";
  final _firestore = Firestore.instance;

  CollectionReference _itemsReference;
  DocumentReference _baseReference;

  FoodBaseApi(String baseId) {
    _baseReference = _firestore.collection(basesReference).document(baseId);
    _itemsReference = _baseReference.collection(itemsReference);
  }

  Stream<QuerySnapshot> streamCollection() {
    return _itemsReference.snapshots();
  }

  Future<QuerySnapshot> getCollection() {
    return _itemsReference.getDocuments();
  }

  Future<DocumentReference> addItemToBase(Map data) {
    return _itemsReference.add(data);
  }

  Future<void> updateBaseItem(String itemId, Map data) {
    return _itemsReference.document(itemId).updateData(data);
  }
}