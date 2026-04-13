/// Form validators for the app
class Validators {
  Validators._();

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates password (min 6 characters)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates name field
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates expense amount
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Enter a valid number';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    if (amount > 10000000) {
      return 'Amount is too large';
    }
    return null;
  }

  /// Validates note field (optional but if given, must be valid)
  static String? validateNote(String? value) {
    if (value != null && value.length > 200) {
      return 'Note must be less than 200 characters';
    }
    return null;
  }
}
