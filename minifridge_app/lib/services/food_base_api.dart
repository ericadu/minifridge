import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minifridge_app/services/collections_api.dart';
// import 'package:minifridge_app/services/document_api.dart';

class FoodBaseApi {
  static final String basesReference = "bases";
  static final String itemsReference = "items";
  final _firestore = Firestore.instance;
  // DocumentApi _baseApi;
  CollectionsApi _itemsApi;

  FoodBaseApi(String baseId) {
    // _baseApi = DocumentApi(
    //   _firestore.collection(basesReference).document(baseId)
    // );

    _itemsApi = CollectionsApi(
      _firestore.collection(basesReference).document(baseId).collection(itemsReference)
    );
  }

  Stream<QuerySnapshot> streamItems() {
    return _itemsApi.streamCollection();
  }

  Future<DocumentReference> addNewItem(Map data) {
    return _itemsApi.addDocument(data);
  }
}