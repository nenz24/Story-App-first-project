import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/model/user.dart';
import '../data/preferences/preferences_helper.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper preferencesHelper;

  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool _isLoadingSession = true;
  String? _errorMessage;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get isLoadingSession => _isLoadingSession;
  String? get errorMessage => _errorMessage;
  String? get userName => _userName;

  AuthProvider({
    required this.apiService,
    required this.preferencesHelper,
  }) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    _isLoadingSession = true;
    notifyListeners();

    _isLoggedIn = await preferencesHelper.isLoggedIn();
    _userName = await preferencesHelper.getName();
    _isLoadingSession = false;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await apiService.register(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final User user = await apiService.login(email, password);
      await preferencesHelper.saveToken(user.token);
      await preferencesHelper.saveSession(true);
      await preferencesHelper.saveName(user.name);
      _isLoggedIn = true;
      _userName = user.name;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await preferencesHelper.clearAll();
    _isLoggedIn = false;
    _userName = null;
    notifyListeners();
  }
}
