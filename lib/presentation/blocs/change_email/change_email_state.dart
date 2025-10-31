import 'package:equatable/equatable.dart';
import '../../../domain/entities/change_email/request_change_email_result.dart';
import '../../../domain/entities/change_email/confirm_change_email_result.dart';

abstract class ChangeEmailState extends Equatable {
  const ChangeEmailState();

  @override
  List<Object> get props => [];
}

class ChangeEmailInitial extends ChangeEmailState {}

class ChangeEmailRequestLoading extends ChangeEmailState {}

class ChangeEmailRequestSuccess extends ChangeEmailState {
  final RequestChangeEmailResult result;
  final String newEmail;

  const ChangeEmailRequestSuccess(this.result, this.newEmail);

  @override
  List<Object> get props => [result, newEmail];
}

class ChangeEmailRequestFailure extends ChangeEmailState {
  final String error;

  const ChangeEmailRequestFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChangeEmailConfirmLoading extends ChangeEmailState {}

class ChangeEmailConfirmSuccess extends ChangeEmailState {
  final ConfirmChangeEmailResult result;

  const ChangeEmailConfirmSuccess(this.result);

  @override
  List<Object> get props => [result];
}

class ChangeEmailConfirmFailure extends ChangeEmailState {
  final String error;

  const ChangeEmailConfirmFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChangeEmailValidationState extends ChangeEmailState {
  final String newEmail;
  final bool isValid;
  final String? validationError;
  final bool hasInteractedWithEmail;

  const ChangeEmailValidationState({
    required this.newEmail,
    required this.isValid,
    this.validationError,
    this.hasInteractedWithEmail = false,
  });

  @override
  List<Object> get props => [
    newEmail,
    isValid,
    validationError ?? '',
    hasInteractedWithEmail,
  ];
}
