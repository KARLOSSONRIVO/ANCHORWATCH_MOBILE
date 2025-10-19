import 'package:equatable/equatable.dart';

class ContactSupportResult extends Equatable {
  final bool success;
  final String message;
  final String? error;
  final int? retryAfterSeconds;

  const ContactSupportResult({
    required this.success,
    required this.message,
    this.error,
    this.retryAfterSeconds,
  });

  factory ContactSupportResult.success(String message) {
    return ContactSupportResult(success: true, message: message);
  }

  factory ContactSupportResult.failure(String error, {int? retryAfterSeconds}) {
    return ContactSupportResult(
      success: false,
      message: '',
      error: error,
      retryAfterSeconds: retryAfterSeconds,
    );
  }

  @override
  List<Object?> get props => [success, message, error, retryAfterSeconds];
}
