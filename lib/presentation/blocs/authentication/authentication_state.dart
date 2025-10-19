import 'package:equatable/equatable.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  loading,
  signUpSuccess,
}

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.error,
    this.isLoading = false,
  });

  final AuthenticationStatus status;
  final String? user;
  final String? error;
  final bool isLoading;
  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, user, error, isLoading];

  @override
  String toString() =>
      'AuthenticationState(status: $status, user: $user, error: $error, isLoading: $isLoading)';
}
