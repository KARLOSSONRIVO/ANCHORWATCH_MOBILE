import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

/// BLoC for managing authentication state
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState()) {
    on<AuthenticationStatusRequested>(_onAuthenticationStatusRequested);
    on<AuthenticationLoginRequested>(_onAuthenticationLoginRequested);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationSignUpRequested>(_onAuthenticationSignUpRequested);
  }

  /// Check authentication status on app start
  void _onAuthenticationStatusRequested(
    AuthenticationStatusRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Simulate checking stored credentials or token
    await Future.delayed(const Duration(milliseconds: 500));
    
    // For demo purposes, assume user is not authenticated
    emit(state.copyWith(
      status: AuthenticationStatus.unauthenticated,
    ));
  }

  /// Handle login request
  void _onAuthenticationLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Emit loading state
    emit(state.copyWith(status: AuthenticationStatus.unknown));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Simple validation for demo
      if (event.username == 'demo' && event.password == 'password') {
        emit(state.copyWith(  
          status: AuthenticationStatus.authenticated,
          user: event.username,
        ));
      } else {
        emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          error: 'Invalid credentials',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        error: 'Login failed: $e',
      ));
    }
  }

  /// Handle logout request
  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Emit loading state during logout
    emit(state.copyWith(
      status: AuthenticationStatus.loading,
      isLoading: true,
      error: null,
    ));

    try {
      // Simulate logout API call or cleanup operations
      await Future.delayed(const Duration(seconds: 1));
      
      // Clear user data and set to unauthenticated
      emit(const AuthenticationState(
        status: AuthenticationStatus.unauthenticated,
        isLoading: false,
      ));
    } catch (e) {
      // Handle any errors during logout
      emit(state.copyWith(
        status: AuthenticationStatus.authenticated, // Keep user logged in if logout fails
        isLoading: false,
        error: 'Logout failed: $e',
      ));
    }
  }

  /// Handle sign-up request
  void _onAuthenticationSignUpRequested(
    AuthenticationSignUpRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Emit loading state
    emit(state.copyWith(
      status: AuthenticationStatus.loading,
      isLoading: true,
      error: null,
    ));

    try {
      // Simulate API call for sign-up
      await Future.delayed(const Duration(seconds: 2));
      
      // Simple validation for demo
      if (event.username.isNotEmpty && event.email.isNotEmpty && event.password.isNotEmpty) {
        emit(state.copyWith(
          status: AuthenticationStatus.signUpSuccess,
          isLoading: false,
          user: event.username,
        ));
      } else {
        emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          isLoading: false,
          error: 'Please fill in all fields',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        isLoading: false,
        error: 'Sign-up failed: $e',
      ));
    }
  }
}