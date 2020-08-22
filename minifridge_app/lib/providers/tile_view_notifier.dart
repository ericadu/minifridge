import 'package:flutter/material.dart';

class TileViewNotifier extends ChangeNotifier {
  bool _expanded = false;
  bool _editMode = false;

  bool get expanded => _expanded;
  bool get editMode => _editMode;

  void onEdit() {
    _editMode = true;
    expand();
    notifyListeners();
  }

  void onView() {
    _editMode = false;
    notifyListeners();
  }

  void expand() {
    _expanded = true;
    notifyListeners();
  }
}