import 'package:equatable/equatable.dart';
class RequestChangeEmailResult extends Equatable {
  final String message;

  const RequestChangeEmailResult({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
