
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsNotifier extends ChangeNotifier {
  static final String _reportsReference = "reports";
  CollectionReference _reference = Firestore.instance.collection(_reportsReference);

  Future<DocumentReference> addReport(Map data) {
    return _reference.add(data);
  }
}