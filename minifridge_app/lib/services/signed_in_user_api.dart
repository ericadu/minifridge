import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minifridge_app/services/document_api.dart';

class SignedInUserApi {
  static final String usersReference = "users";
  final _firestore = Firestore.instance;
  DocumentApi _userApi;
  
  SignedInUserApi(String userId) {
    _userApi = DocumentApi(
      _firestore.collection(usersReference).document(userId)
    );
  }

  Future<DocumentSnapshot> getUser() {
    return _userApi.getDocument();
  }

  Stream<DocumentSnapshot> streamUser() {
    return _userApi.streamDocument();
  }
}