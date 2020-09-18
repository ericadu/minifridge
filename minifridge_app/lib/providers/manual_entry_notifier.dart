import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';

class ManualEntryNotifier extends ChangeNotifier {
  bool _showManualAdd = false;
  int _currentStep = 0;
  bool _complete = false;
  int _stepLength;
  String _itemName = "";
  String _category = "Uncategorized";
  String _refDate = DateFormat.yMMMEd().format(DateTime.now());
  bool _perishable = false;
  List<int> _range = [5, 7];
  // static final _itemNameController = TextEditingController();
  // static final _dateController = TextEditingController();

  bool get showManualAdd => _showManualAdd;
  int get currentStep => _currentStep;
  bool get complete => _complete;
  String get itemName => _itemName;
  String get category => _category;
  // String get expDate => _expDate;
  String get refDate => _refDate;
  int get stepLength => _stepLength;
  // TextEditingController get itemNameController => _itemNameController;
  // TextEditingController get dateController => _dateController;

  void setStepLength(int stepLength) {
    _stepLength = stepLength;
  }

  void setDate(DateTime newExp) {
    _refDate = DateFormat.yMMMEd().format(newExp);
    notifyListeners();
  }

  void setCategory(String newCategory) {
    _category = newCategory;
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
    
    if (isNotEmpty(_itemName)) {
      goTo(currentStep + 1);
    }
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