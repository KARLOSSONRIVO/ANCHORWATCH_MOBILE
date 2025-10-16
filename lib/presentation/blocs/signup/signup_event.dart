import 'package:equatable/equatable.dart';

/// Events for signup form validation and submission
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

/// Event for username input change
class SignUpUsernameChanged extends SignUpEvent {
  const SignUpUsernameChanged({required this.username});

  final String username;

  @override
  List<Object?> get props => [username];
}

/// Event for email input change
class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Event for password input change
class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged({required this.password});

  final String password;

  @override
  List<Object?> get props => [password];
}

/// Event for confirm password input change
class SignUpConfirmPasswordChanged extends SignUpEvent {
  const SignUpConfirmPasswordChanged({required this.confirmPassword});

  final String confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}

/// Event to submit the signup form
class SignUpFormSubmitted extends SignUpEvent {
  const SignUpFormSubmitted();
}

/// Event to reset validation state
class SignUpValidationReset extends SignUpEvent {
  const SignUpValidationReset();
}