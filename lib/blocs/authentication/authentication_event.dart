import 'package:equatable/equatable.dart';

/// Base class for authentication events
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

/// Event to check if user is already logged in
class AuthenticationStatusRequested extends AuthenticationEvent {
  const AuthenticationStatusRequested();
}

/// Event to log in a user
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

/// Event to log out a user
class AuthenticationLogoutRequested extends AuthenticationEvent {
  const AuthenticationLogoutRequested();
}