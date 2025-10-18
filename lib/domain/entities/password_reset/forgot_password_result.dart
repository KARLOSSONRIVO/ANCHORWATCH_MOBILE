import 'package:equatable/equatable.dart';
class ForgotPasswordResult extends Equatable {
  final String message;

  const ForgotPasswordResult({
    required this.message,
  });

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return 'ForgotPasswordResult(message: $message)';
  }
}
