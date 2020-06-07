import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minifridge_app/services/firestore.dart';

class UsersApi extends FirestoreApi {
  static final String usersApi = "users";
  static final String itemsApi = "user_items";

  UsersApi() : super(usersApi);

  CollectionReference userItemsReference(String uid) {
    return this.subcollectionReference(uid, itemsApi);
  }
}