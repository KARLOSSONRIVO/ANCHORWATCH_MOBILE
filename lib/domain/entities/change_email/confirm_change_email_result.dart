import 'package:equatable/equatable.dart';

/// Result entity for confirming email change
class ConfirmChangeEmailResult extends Equatable {
  final String message;

  const ConfirmChangeEmailResult({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}