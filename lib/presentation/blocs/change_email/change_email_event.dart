import 'package:equatable/equatable.dart';

abstract class ChangeEmailEvent extends Equatable {
  const ChangeEmailEvent();

  @override
  List<Object> get props => [];
}

class RequestChangeEmailSubmitted extends ChangeEmailEvent {
  final String newEmail;

  const RequestChangeEmailSubmitted({required this.newEmail});

  @override
  List<Object> get props => [newEmail];
}

class ConfirmChangeEmailSubmitted extends ChangeEmailEvent {
  final String otp;
  final String newEmail;

  const ConfirmChangeEmailSubmitted({
    required this.otp,
    required this.newEmail,
  });

  @override
  List<Object> get props => [otp, newEmail];
}

class ChangeEmailValidationRequested extends ChangeEmailEvent {
  final String newEmail;
  final bool hasInteractedWithEmail;

  const ChangeEmailValidationRequested({
    required this.newEmail,
    this.hasInteractedWithEmail = false,
  });

  @override
  List<Object> get props => [newEmail, hasInteractedWithEmail];
}

class ChangeEmailReset extends ChangeEmailEvent {}
