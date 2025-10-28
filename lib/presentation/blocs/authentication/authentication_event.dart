import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusRequested extends AuthenticationEvent {
  const AuthenticationStatusRequested();
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  const AuthenticationLoginRequested({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {
  const AuthenticationLogoutRequested();
}

class AuthenticationSignUpRequested extends AuthenticationEvent {
  const AuthenticationSignUpRequested({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;

  @override
  List<Object> get props => [username, email, password];
}

class AuthenticationUsernameUpdated extends AuthenticationEvent {
  const AuthenticationUsernameUpdated({required this.newUsername});

  final String newUsername;

  @override
  List<Object> get props => [newUsername];
}

class AuthenticationErrorCleared extends AuthenticationEvent {
  const AuthenticationErrorCleared();
}

class AuthenticationSessionExpired extends AuthenticationEvent {
  const AuthenticationSessionExpired();
}
