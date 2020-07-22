import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualEntryNotifier extends ChangeNotifier {
  bool _showManualAdd = false;
  int _currentStep = 0;
  bool _complete = false;
  int _stepLength;
  static final _itemNameController = TextEditingController();
  static final _dateController = TextEditingController();

  bool get showManualAdd => _showManualAdd;
  int get currentStep => _currentStep;
  bool get complete => _complete;
  String get itemName => _itemNameController.text;
  String get expDate => _dateController.text;
  int get stepLength => _stepLength;
  TextEditingController get itemNameController => _itemNameController;
  TextEditingController get dateController => _dateController;

  void setStepLength(int stepLength) {
    _stepLength = stepLength;
  }

  void setDate(DateTime newExp) {
    _dateController.text = DateFormat.yMMMEd().format(newExp);
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

  next() {
    goTo(currentStep + 1);
  }

  cancel() {
    if (currentStep <= 0) return;
    goTo(currentStep - 1);
  }

  reset() {
    _currentStep = 0;
    _showManualAdd = false;
    _itemNameController.text = '';
    _dateController.text = '';
    notifyListeners();
  }
}