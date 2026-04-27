import 'package:flutter/material.dart';

class PageManager extends ChangeNotifier {
  String? _selectedStoryId;
  bool _isAddStory = false;
  bool _isRegister = false;

  String? get selectedStoryId => _selectedStoryId;
  bool get isAddStory => _isAddStory;
  bool get isRegister => _isRegister;

  void selectStory(String id) {
    _selectedStoryId = id;
    notifyListeners();
  }

  void clearSelectedStory() {
    _selectedStoryId = null;
    notifyListeners();
  }

  void openAddStory() {
    _isAddStory = true;
    notifyListeners();
  }

  void closeAddStory() {
    _isAddStory = false;
    notifyListeners();
  }

  void openRegister() {
    _isRegister = true;
    notifyListeners();
  }

  void closeRegister() {
    _isRegister = false;
    notifyListeners();
  }

  void resetAllNavigation() {
    _selectedStoryId = null;
    _isAddStory = false;
    _isRegister = false;
    notifyListeners();
  }
}
