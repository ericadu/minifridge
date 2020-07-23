import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualEntryNotifier extends ChangeNotifier {
  bool _showManualAdd = false;
  int _currentStep = 0;
  bool _complete = false;
  int _stepLength;
  String _itemName;
  String _expDate;
  // static final _itemNameController = TextEditingController();
  // static final _dateController = TextEditingController();

  bool get showManualAdd => _showManualAdd;
  int get currentStep => _currentStep;
  bool get complete => _complete;
  String get itemName => _itemName;
  String get expDate => _expDate;
  int get stepLength => _stepLength;
  // TextEditingController get itemNameController => _itemNameController;
  // TextEditingController get dateController => _dateController;

  void setStepLength(int stepLength) {
    _stepLength = stepLength;
  }

  void setDate(DateTime newExp) {
    _expDate = DateFormat.yMMMEd().format(newExp);
    notifyListeners();
  }

  show() {
    _showManualAdd = true;
    notifyListeners();
  }

  goTo(int step) {
    _currentStep = step;
    notifyListeners();
  }

  next(String name) {
    _itemName = name;
    goTo(currentStep + 1);
  }

  cancel() {
    if (currentStep <= 0) return;
    goTo(currentStep - 1);
  }

  reset() {
    _showManualAdd = false;
    _currentStep = 0;
    notifyListeners();
  }
}