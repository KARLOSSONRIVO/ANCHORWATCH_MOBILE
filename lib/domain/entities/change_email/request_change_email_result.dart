import 'package:equatable/equatable.dart';

/// Result entity for requesting email change
class RequestChangeEmailResult extends Equatable {
  final String message;

  const RequestChangeEmailResult({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}