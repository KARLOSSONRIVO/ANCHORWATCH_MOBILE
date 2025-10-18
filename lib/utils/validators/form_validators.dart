/// Centralized form validation utilities
///
/// This class provides reusable validation methods for all forms in the app.
/// All validators return null if valid, or an error message string if invalid.
class FormValidators {
  // Private constructor to prevent instantiation
  FormValidators._();

  /// Validates username input
  ///
  /// Rules:
  /// - Cannot be empty
  /// - Must be at least 3 characters
  /// - Cannot exceed 30 characters
  /// - Can only contain letters, numbers, and underscores
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (trimmedValue.length > 30) {
      return 'Username cannot exceed 30 characters';
    }

    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(trimmedValue)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  /// Validates email input
  ///
  /// Rules:
  /// - Cannot be empty
  /// - Must match email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }

    final trimmedValue = value.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password input
  ///
  /// Rules:
  /// - Cannot be empty
  /// - Must be at least [minLength] characters (default: 8)
  static String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }

    return null;
  }

  /// Validates password confirmation
  ///
  /// Rules:
  /// - Cannot be empty
  /// - Must match the original password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates OTP/verification code input
  ///
  /// Rules:
  /// - Cannot be empty
  /// - Must be exactly [length] digits (default: 6)
  static String? validateOtp(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the verification code';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length != length) {
      return 'Verification code must be $length digits';
    }

    // Optionally check if it's all digits
    if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
      return 'Verification code must contain only numbers';
    }

    return null;
  }

  /// Generic required field validator
  ///
  /// Rules:
  /// - Cannot be empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  /// Validates that username or email is provided (for login)
  ///
  /// Rules:
  /// - Cannot be empty
  static String? validateUsernameOrEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your username or email';
    }
    return null;
  }

  /// Validates a message/text field with minimum length
  ///
  /// Rules:
  /// - Cannot be empty
  /// - Must be at least [minLength] characters
  static String? validateMessage(String? value, {int minLength = 10}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a message';
    }

    if (value.trim().length < minLength) {
      return 'Message must be at least $minLength characters';
    }

    return null;
  }
}
