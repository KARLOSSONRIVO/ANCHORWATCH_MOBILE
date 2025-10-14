import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../services/authentication_service.dart';
import '../../../services/dio_client.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

/// BLoC for managing authentication state
@injectable
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthenticationService _authenticationService;

  AuthenticationBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._authenticationService,
  ) : super(const AuthenticationState()) {
    on<AuthenticationStatusRequested>(_onAuthenticationStatusRequested);
    on<AuthenticationLoginRequested>(_onAuthenticationLoginRequested);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationSignUpRequested>(_onAuthenticationSignUpRequested);
    on<AuthenticationUsernameUpdated>(_onAuthenticationUsernameUpdated);
  }

  /// Check authentication status on app start
  void _onAuthenticationStatusRequested(
    AuthenticationStatusRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final isAuthenticated = await _authenticationService.isAuthenticated();
      
      if (isAuthenticated) {
        // Update DioClient with the stored auth token
        _authenticationService.updateDioClientToken();
        
        // Get actual user info from stored data or fetch from server
        final userProfile = await _authenticationService.fetchUserProfile();
        final username = userProfile?.username ?? _authenticationService.getUserName() ?? 'Current User';
        
        emit(state.copyWith(
          status: AuthenticationStatus.authenticated,
          user: username,
          error: null,
        ));
      } else {
        emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          error: null,
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
      
      // Successful login - clear any previous error
      emit(state.copyWith(  
        status: AuthenticationStatus.authenticated,
        user: authResult.user.username,
        isLoading: false,
        error: null,
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
      // Use the RegisterUseCase to perform registration
      final authResult = await _registerUseCase(
        username: event.username,
        email: event.email,
        password: event.password,
      );

      // Store authentication result
      final stored = await _authenticationService.storeAuthResult(authResult);
      
      if (stored) {
        // Successful registration - set as authenticated
        emit(state.copyWith(
          status: AuthenticationStatus.authenticated,
          isLoading: false,
          user: authResult.user.username,
          error: null,
        ));
      } else {
        emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          isLoading: false,
          error: 'Failed to store authentication data',
        ));
      }
    } catch (e) {
      // Handle registration failure - show API error message directly
      String errorMessage;
      if (e is AppException) {
        // For API errors, show the exact message from the server
        errorMessage = e.message;
      } else {
        // For other errors, add context
        errorMessage = 'Registration failed: $e';
      }
      
      emit(state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        isLoading: false,
        error: errorMessage,
      ));
    }
  }

  /// Handle username update
  void _onAuthenticationUsernameUpdated(
    AuthenticationUsernameUpdated event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      // Update the stored username
      await _authenticationService.updateUserProfile(name: event.newUsername);
      
      // Update the authentication state with new username
      emit(state.copyWith(
        user: event.newUsername,
        error: null,
      ));
    } catch (e) {
      // If update fails, log error but don't change state
      print('Failed to update stored username: $e');
    }
  }
}