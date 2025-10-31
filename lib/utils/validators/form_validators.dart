class FormValidators {
  FormValidators._();
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

  static String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? validateOtp(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the verification code';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length != length) {
      return 'Verification code must be $length digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
      return 'Verification code must contain only numbers';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  static String? validateUsernameOrEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your username or email';
    }
    return null;
  }

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
