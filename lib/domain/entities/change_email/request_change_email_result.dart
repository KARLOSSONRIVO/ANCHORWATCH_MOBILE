import 'package:equatable/equatable.dart';

class RequestChangeEmailResult extends Equatable {
  final bool success;
  final String message;
  final String? error;

  const RequestChangeEmailResult({
    required this.success,
    required this.message,
    this.error,
  });

  factory RequestChangeEmailResult.success(String message) {
    return RequestChangeEmailResult(success: true, message: message);
  }

  factory RequestChangeEmailResult.failure(String error) {
    return RequestChangeEmailResult(success: false, message: '', error: error);
  }

  @override
  List<Object?> get props => [success, message, error];
}
