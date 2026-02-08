import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ SAME KEY as LanguageScreen
    final code = prefs.getString('languageCode') ?? 'en';

    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> changeLanguage(String code) async {
    _locale = Locale(code);

    final prefs = await SharedPreferences.getInstance();

    // ✅ SAME KEY
    await prefs.setString('languageCode', code);

    notifyListeners();
  }
}
