class ProfileActionResult {
  final bool isSuccess;
  final String message;
  final String? updatedName;
  final String? updatedEmail;

  const ProfileActionResult._({
    required this.isSuccess,
    required this.message,
    this.updatedName,
    this.updatedEmail,
  });

  factory ProfileActionResult.success({
    required String message,
    String? updatedName,
    String? updatedEmail,
  }) {
    return ProfileActionResult._(
      isSuccess: true,
      message: message,
      updatedName: updatedName,
      updatedEmail: updatedEmail,
    );
  }

  factory ProfileActionResult.error({required String message}) {
    return ProfileActionResult._(
      isSuccess: false,
      message: message,
    );
  }

  bool get hasProfileUpdates => updatedName != null || updatedEmail != null;
}
