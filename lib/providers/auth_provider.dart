import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';

/// Provider for handling authentication state and user operations
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get error => _error;

  /// Check if user is already logged in (persistent login)
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay for realism
    await Future.delayed(const Duration(milliseconds: 800));

    final userId = HiveService.getCurrentUserId();
    if (userId != null) {
      final user = HiveService.usersBox.get(userId);
      if (user != null) {
        _currentUser = user;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      // Find user by email
      final users = HiveService.usersBox.values.toList();
      final user = users.where(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      if (user.isEmpty) {
        _error = 'No account found with this email';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (user.first.password != password) {
        _error = 'Incorrect password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user.first;
      await HiveService.saveCurrentUserId(_currentUser!.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up a new user
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      // Check if email already exists
      final existingUsers = HiveService.usersBox.values.where(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      if (existingUsers.isNotEmpty) {
        _error = 'An account with this email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final userId = const Uuid().v4();
      final user = UserModel(
        id: userId,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        password: password,
        createdAt: DateTime.now(),
      );

      await HiveService.usersBox.put(userId, user);
      _currentUser = user;
      await HiveService.saveCurrentUserId(userId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await HiveService.clearCurrentUser();
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
