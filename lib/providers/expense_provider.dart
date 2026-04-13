import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/expense_model.dart';
import '../services/hive_service.dart';

/// Provider for managing expense data and operations
class ExpenseProvider extends ChangeNotifier {
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;
  String? _userId;

  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;

  /// Total expenses amount
  double get totalExpenses =>
      _expenses.fold(0.0, (sum, expense) => sum + expense.amount);

  /// Recent expenses (latest 5)
  List<ExpenseModel> get recentExpenses => _expenses.take(5).toList();

  /// Category-wise totals
  Map<ExpenseCategory, double> get categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    for (final category in ExpenseCategory.values) {
      final total = _expenses
          .where((e) => e.category == category)
          .fold(0.0, (sum, e) => sum + e.amount);
      if (total > 0) {
        totals[category] = total;
      }
    }
    return totals;
  }

  /// Set current user and load their expenses
  Future<void> setUser(String userId) async {
    _userId = userId;
    await loadExpenses();
  }

  /// Load all expenses for the current user
  Future<void> loadExpenses() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    // Simulate loading delay for shimmer effect
    await Future.delayed(const Duration(milliseconds: 500));

    final allExpenses = HiveService.expensesBox.values
        .where((e) => e.userId == _userId)
        .toList();

    // Sort by date (latest first)
    allExpenses.sort((a, b) => b.date.compareTo(a.date));
    _expenses = allExpenses;

    _isLoading = false;
    notifyListeners();
  }

  /// Add a new expense
  Future<void> addExpense({
    required double amount,
    required ExpenseCategory category,
    required String note,
    required DateTime date,
  }) async {
    if (_userId == null) return;

    final expenseId = const Uuid().v4();
    final expense = ExpenseModel(
      id: expenseId,
      userId: _userId!,
      amount: amount,
      category: category,
      note: note,
      date: date,
      createdAt: DateTime.now(),
    );

    await HiveService.expensesBox.put(expenseId, expense);

    // Insert at correct position (sorted by date)
    _expenses.insert(0, expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  /// Update an existing expense
  Future<void> updateExpense({
    required String id,
    required double amount,
    required ExpenseCategory category,
    required String note,
    required DateTime date,
  }) async {
    final existingExpense = HiveService.expensesBox.get(id);
    if (existingExpense == null) return;

    final updatedExpense = ExpenseModel(
      id: id,
      userId: existingExpense.userId,
      amount: amount,
      category: category,
      note: note,
      date: date,
      createdAt: existingExpense.createdAt,
    );

    await HiveService.expensesBox.put(id, updatedExpense);

    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      _expenses.sort((a, b) => b.date.compareTo(a.date));
    }
    notifyListeners();
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    await HiveService.expensesBox.delete(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Clear all data (for logout)
  void clear() {
    _expenses = [];
    _userId = null;
    notifyListeners();
  }
}
