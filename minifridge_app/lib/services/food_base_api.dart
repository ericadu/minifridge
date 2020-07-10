import 'package:cloud_firestore/cloud_firestore.dart';

class FoodBaseApi {
  static final String basesReference = "bases";
  static final String itemsReference = "items";
  final _firestore = Firestore.instance;
  // DocumentApi _baseApi;
  CollectionReference _itemsReference;

  FoodBaseApi(String baseId) {
    // _baseApi = DocumentApi(
    //   _firestore.collection(basesReference).document(baseId)
    // );

    _itemsReference = _firestore.collection(basesReference).document(baseId).collection(itemsReference);
  }

    Stream<QuerySnapshot> streamCollection() {
      return _itemsReference.snapshots();
    }

    Future<QuerySnapshot> getCollection() {
      return _itemsReference.getDocuments();
    }

    Future<DocumentReference> addDocument(Map data) {
      return _itemsReference.add(data);
    }

    Future<void> updateDocument(String itemId, Map data) {
      return _itemsReference.document(itemId).updateData(data);
    }
}