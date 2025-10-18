import 'package:equatable/equatable.dart';
class ConfirmChangeEmailResult extends Equatable {
  final String message;

  const ConfirmChangeEmailResult({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
