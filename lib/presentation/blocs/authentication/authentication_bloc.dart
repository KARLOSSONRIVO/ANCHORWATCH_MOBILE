import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/use_cases/auth/login_use_case.dart';
import '../../../services/authentication_service.dart';
import '../../../services/dio_client.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

/// BLoC for managing authentication state
@injectable
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUseCase _loginUseCase;
  final AuthenticationService _authenticationService;

  AuthenticationBloc(
    this._loginUseCase,
    this._authenticationService,
  ) : super(const AuthenticationState()) {
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
    try {
      final isAuthenticated = await _authenticationService.isAuthenticated();
      
      if (isAuthenticated) {
        // Could get user info from stored data here
        emit(state.copyWith(
          status: AuthenticationStatus.authenticated,
          user: 'Current User', // You might want to get actual user info
        ));
      } else {
        emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        error: 'Failed to check authentication status: $e',
      ));
    }
  }

  /// Handle login request
  void _onAuthenticationLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Emit loading state
    emit(state.copyWith(
      status: AuthenticationStatus.loading,
      isLoading: true,
      error: null,
    ));

    try {
      // Use the LoginUseCase to perform login
      final authResult = await _loginUseCase(
        email: event.username, // Assuming username is email
        password: event.password,
      );
      
      // Store the authentication result (tokens + user info)
      await _authenticationService.storeAuthResult(authResult);
      
      // Successful login
      emit(state.copyWith(  
        status: AuthenticationStatus.authenticated,
        user: authResult.user.username,
        isLoading: false,
      ));
    } catch (e) {
      // Handle login failure - show API error message directly
      String errorMessage;
      if (e is AppException) {
        // For API errors, show the exact message from the server
        errorMessage = e.message;
      } else {
        // For other errors, add context
        errorMessage = 'Login failed: $e';
      }
      
      emit(state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        isLoading: false,
        error: errorMessage,
      ));
    }
  }

  /// Handle logout request
  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    print('🚪 AuthenticationBloc: Logout requested');
    
    // Emit loading state during logout
    emit(state.copyWith(
      status: AuthenticationStatus.loading,
      isLoading: true,
      error: null,
    ));
    print('🔄 AuthenticationBloc: Emitted loading state');

    try {
      // Use the AuthenticationService to logout and clear tokens
      final result = await _authenticationService.logout();
      print('🚪 AuthenticationBloc: Logout service result: $result');
      
      // Clear user data and set to unauthenticated
      emit(const AuthenticationState(
        status: AuthenticationStatus.unauthenticated,
        isLoading: false,
      ));
      print('✅ AuthenticationBloc: Emitted unauthenticated state');
    } catch (e) {
      print('❌ AuthenticationBloc: Logout error: $e');
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