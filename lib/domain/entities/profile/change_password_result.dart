class ChangePasswordResult {
  final bool success;
  final String message;
  final String? error;

  const ChangePasswordResult({
    required this.success,
    required this.message,
    this.error,
  });

  factory ChangePasswordResult.success(String message) {
    return ChangePasswordResult(
      success: true,
      message: message,
    );
  }

  factory ChangePasswordResult.failure(String error) {
    return ChangePasswordResult(
      success: false,
      message: '',
      error: error,
    );
  }
}
