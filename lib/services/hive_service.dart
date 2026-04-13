import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/expense_model.dart';
import '../utils/constants.dart';

/// Service class that manages all Hive database operations
class HiveService {
  static late Box<UserModel> _usersBox;
  static late Box<ExpenseModel> _expensesBox;
  static late Box _settingsBox;

  /// Initialize Hive and register adapters
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ExpenseModelAdapter());
    Hive.registerAdapter(ExpenseCategoryAdapter());

    // Open boxes
    _usersBox = await Hive.openBox<UserModel>(AppConstants.usersBox);
    _expensesBox = await Hive.openBox<ExpenseModel>(AppConstants.expensesBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  // ── User Operations ─────────────────────────────────────────
  static Box<UserModel> get usersBox => _usersBox;
  static Box<ExpenseModel> get expensesBox => _expensesBox;
  static Box get settingsBox => _settingsBox;

  /// Save current user ID for persistent login
  static Future<void> saveCurrentUserId(String userId) async {
    await _settingsBox.put(AppConstants.currentUserKey, userId);
  }

  /// Get current logged-in user ID
  static String? getCurrentUserId() {
    return _settingsBox.get(AppConstants.currentUserKey);
  }

  /// Clear current user (logout)
  static Future<void> clearCurrentUser() async {
    await _settingsBox.delete(AppConstants.currentUserKey);
  }

  /// Get dark mode preference
  static bool getDarkMode() {
    return _settingsBox.get(AppConstants.darkModeKey, defaultValue: false);
  }

  /// Save dark mode preference
  static Future<void> setDarkMode(bool value) async {
    await _settingsBox.put(AppConstants.darkModeKey, value);
  }
}
