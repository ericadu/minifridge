import 'package:minifridge_app/services/firestore.dart';

class UserItemsApi extends FirestoreApi {
  static final String usersApi = "users";
  static final String itemsApi = "currentItems";

  UserItemsApi(String docId) : super.fromSubcollection(usersApi, docId, itemsApi);
}