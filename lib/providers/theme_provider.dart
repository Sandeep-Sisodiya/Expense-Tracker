import 'package:flutter/material.dart';
import '../services/hive_service.dart';

/// Provider for managing theme (dark/light mode)
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;

  ThemeProvider() : _isDarkMode = HiveService.getDarkMode();

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Toggle between dark and light mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await HiveService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
