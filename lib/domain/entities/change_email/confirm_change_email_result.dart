import 'package:equatable/equatable.dart';

class ConfirmChangeEmailResult extends Equatable {
  final bool success;
  final String message;
  final String? error;

  const ConfirmChangeEmailResult({
    required this.success,
    required this.message,
    this.error,
  });

  factory ConfirmChangeEmailResult.success(String message) {
    return ConfirmChangeEmailResult(success: true, message: message);
  }

  factory ConfirmChangeEmailResult.failure(String error) {
    return ConfirmChangeEmailResult(success: false, message: '', error: error);
  }

  @override
  List<Object?> get props => [success, message, error];
}
