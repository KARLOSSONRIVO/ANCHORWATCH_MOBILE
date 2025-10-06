import 'package:equatable/equatable.dart';

/// Result for password reset operation
class ResetPasswordResult extends Equatable {
  final String message;

  const ResetPasswordResult({
    required this.message,
  });

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return 'ResetPasswordResult(message: $message)';
  }
}