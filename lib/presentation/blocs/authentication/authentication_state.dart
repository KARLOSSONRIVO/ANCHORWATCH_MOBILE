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
    this.successMessage,
  });

  final AuthenticationStatus status;
  final String? user;
  final String? error;
  final bool isLoading;
  final String? successMessage;

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? user,
    String? error,
    bool? isLoading,
    String? successMessage,
    bool clearUser = false,
    bool clearError = false,
    bool clearSuccessMessage = false,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, error, isLoading, successMessage];

  @override
  String toString() =>
      'AuthenticationState(status: $status, user: $user, error: $error, isLoading: $isLoading, successMessage: $successMessage)';
}
