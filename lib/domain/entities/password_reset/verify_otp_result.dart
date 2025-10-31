import 'package:equatable/equatable.dart';
class VerifyOtpResult extends Equatable {
  final String message;
  final String email;

  const VerifyOtpResult({
    required this.message,
    required this.email,
  });

  @override
  List<Object?> get props => [message, email];

  @override
  String toString() {
    return 'VerifyOtpResult(message: $message, email: $email)';
  }
}
