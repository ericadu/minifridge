
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/report.dart';

class ReportsNotifier extends ChangeNotifier {
  static final String _reportsReference = "reports";
  CollectionReference _reference = Firestore.instance.collection(_reportsReference);

  Future<DocumentReference> addReport(Report report) {
    return _reference.add(report.toJson());
  }
}