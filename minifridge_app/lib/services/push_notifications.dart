import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  String _userId;

  PushNotificationService(String userId) {
    _userId = userId;
    init();
  }

  Future<void> init() async {
    if (!_initialized) {
      if (Platform.isIOS) {
        _firebaseMessaging.requestNotificationPermissions();
      }
      
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );

      _firebaseMessaging.getToken().then((token) {
        print('token: $token');
        Firestore.instance
          .collection('users')
          .document(_userId)
          .updateData({'pushToken': token});
      }).catchError((err) {
        print(err.message.toString());
      });
      
      _initialized = true;
    }
  }
}