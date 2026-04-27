import 'package:flutter/material.dart';
import '../data/preferences/preferences_helper.dart';

class LocalizationProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocalizationProvider({required this.preferencesHelper}) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final localeCode = await preferencesHelper.getLocale();
    _locale = Locale(localeCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await preferencesHelper.saveLocale(locale.languageCode);
    notifyListeners();
  }
}
