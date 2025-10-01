import 'package:equatable/equatable.dart';

/// Authentication status enum
enum AuthenticationStatus { unknown, authenticated, unauthenticated }

/// Authentication state
class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.error,
  });

  final AuthenticationStatus status;
  final String? user;
  final String? error;

  /// Creates a copy with new values
  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? user,
    String? error,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];

  @override
  String toString() => 'AuthenticationState(status: $status, user: $user, error: $error)';
}