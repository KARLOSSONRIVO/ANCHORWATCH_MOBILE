class ChangeUsernameResult {
  final bool success;
  final String message;
  final String? error;

  const ChangeUsernameResult({
    required this.success,
    required this.message,
    this.error,
  });

  factory ChangeUsernameResult.success(String message) {
    return ChangeUsernameResult(
      success: true,
      message: message,
    );
  }

  factory ChangeUsernameResult.failure(String error) {
    return ChangeUsernameResult(
      success: false,
      message: '',
      error: error,
    );
  }
}