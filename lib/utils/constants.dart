import 'package:flutter/material.dart';
import '../models/expense_model.dart';

/// App-wide constants for categories, colors, and configuration
class AppConstants {
  AppConstants._();

  static const String appName = 'Smart Expense Tracker';
  static const String usersBox = 'users_box';
  static const String expensesBox = 'expenses_box';
  static const String settingsBox = 'settings_box';
  static const String currentUserKey = 'current_user_id';
  static const String darkModeKey = 'dark_mode';

  /// Category display info
  static const Map<ExpenseCategory, CategoryInfo> categoryData = {
    ExpenseCategory.food: CategoryInfo(
      label: 'Food',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFFF6B6B),
      gradient: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
    ),
    ExpenseCategory.travel: CategoryInfo(
      label: 'Travel',
      icon: Icons.flight_rounded,
      color: Color(0xFF4ECDC4),
      gradient: [Color(0xFF4ECDC4), Color(0xFF44B09E)],
    ),
    ExpenseCategory.shopping: CategoryInfo(
      label: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFFA29BFE),
      gradient: [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
    ),
    ExpenseCategory.bills: CategoryInfo(
      label: 'Bills',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFFFFA502),
      gradient: [Color(0xFFFFA502), Color(0xFFE67E22)],
    ),
    ExpenseCategory.others: CategoryInfo(
      label: 'Others',
      icon: Icons.more_horiz_rounded,
      color: Color(0xFF636E72),
      gradient: [Color(0xFF636E72), Color(0xFF2D3436)],
    ),
  };
}

/// Holds display information for an expense category
class CategoryInfo {
  final String label;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  const CategoryInfo({
    required this.label,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}
