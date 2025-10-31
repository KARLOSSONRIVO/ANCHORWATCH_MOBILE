import 'package:equatable/equatable.dart';
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}
class SignUpUsernameChanged extends SignUpEvent {
  const SignUpUsernameChanged({required this.username});

  final String username;

  @override
  List<Object?> get props => [username];
}
class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged({required this.password});

  final String password;

  @override
  List<Object?> get props => [password];
}
class SignUpConfirmPasswordChanged extends SignUpEvent {
  const SignUpConfirmPasswordChanged({required this.confirmPassword});

  final String confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}
class SignUpFormSubmitted extends SignUpEvent {
  const SignUpFormSubmitted();
}
class SignUpValidationReset extends SignUpEvent {
  const SignUpValidationReset();
}
