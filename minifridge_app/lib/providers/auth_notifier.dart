import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/signed_in_user.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
}

const String SUCCESS_MESSAGE = "Success";

class AuthNotifier with ChangeNotifier {
  final _firestore = Firestore.instance;
  FirebaseAuth _auth;
  FirebaseUser _user;
  SignedInUser _signedInUser;
  Status _status = Status.Unauthenticated;

  AuthNotifier.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  SignedInUser get signedInUser => _signedInUser;

  Future<String> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return SUCCESS_MESSAGE;
    } catch (e) {
      _status = Status.Unauthenticated;
      print('''
        caught firebase auth exception\n
        ${e.code}\n
        ${e.message}
      ''');
      notifyListeners();
      String errorMessage;
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      return errorMessage;
    }
  }

  Future<SignedInUser> _getSignedInUser(String uid) async {

    DocumentSnapshot snapshot = await _firestore
      .collection("users")
      .document(uid)
      .get();
    
    if (snapshot != null && snapshot.exists) {
      return SignedInUser.fromSnapshot(snapshot);
    } 
    
    try {
      return await _createBaseAndUser(_user.uid, _user.email);
    } catch (e) {
      print('''
        caught firestore create base and user exception\n
        ${e.code}\n
        ${e.message}
      ''');
      return null;
    }
  }

  Future<SignedInUser> _createBaseAndUser(String uid, String email) async {
    DocumentReference ref = await _firestore
      .collection("bases")
      .add({
        "owner": uid,
      });
    
    _firestore
      .collection("users")
      .document(uid)
      .setData({
        "baseId": ref.documentID,
        "email": email
      });
    
    return SignedInUser(id: uid, baseId: ref.documentID);
  }

  Future<String> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return SUCCESS_MESSAGE;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      String errorMessage;
      switch (e.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Anonymous accounts are not enabled";
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Your password is too weak";
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email is invalid";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Email is already in use on different account";
          break;
        case "ERROR_INVALID_CREDENTIAL":
          errorMessage = "Your email is invalid";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      return errorMessage;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      _signedInUser = null;
      notifyListeners();
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _getSignedInUser(_user.uid)
        .then((val) => _signedInUser = val)
        .whenComplete(() => notifyListeners());
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e.message();
    }
  }
}