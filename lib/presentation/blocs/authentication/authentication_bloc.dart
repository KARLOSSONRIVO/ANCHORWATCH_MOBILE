import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../services/authentication_service.dart';
import '../../../services/dio_client.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
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
  void _onAuthenticationStatusRequested(
    AuthenticationStatusRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final isAuthenticated = await _authenticationService.isAuthenticated();

      if (isAuthenticated) {
        _authenticationService.updateDioClientToken();
        final userProfile = await _authenticationService.fetchUserProfile();
        final username =
            userProfile?.username ??
            _authenticationService.getUserName() ??
            'Current User';

        emit(
          state.copyWith(
            status: AuthenticationStatus.authenticated,
            user: username,
            clearError: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            clearError: true,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          error: 'Failed to check authentication status: $e',
        ),
      );
    }
  }

  void _onAuthenticationLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthenticationStatus.loading,
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final authResult = await _loginUseCase(
        email: event.username, // Assuming username is email
        password: event.password,
      );
      await _authenticationService.storeAuthResult(authResult);
      emit(
        state.copyWith(
          status: AuthenticationStatus.authenticated,
          user: authResult.user.username,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (e) {
      String errorMessage;
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Login failed: $e';
      }

      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          isLoading: false,
          error: errorMessage,
        ),
      );
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthenticationStatus.loading,
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final logoutResult = await _authenticationService.logout();

      if (logoutResult) {
        emit(
          state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            isLoading: false,
            clearUser: true,
            clearError: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthenticationStatus.authenticated,
            isLoading: false,
            error: 'Logout failed: Unable to clear authentication data',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.authenticated,
          isLoading: false,
          error: 'Logout failed: $e',
        ),
      );
    }
  }

  void _onAuthenticationSignUpRequested(
    AuthenticationSignUpRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthenticationStatus.loading,
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final authResult = await _registerUseCase(
        username: event.username,
        email: event.email,
        password: event.password,
      );
      final stored = await _authenticationService.storeAuthResult(authResult);

      if (stored) {
        emit(
          state.copyWith(
            status: AuthenticationStatus.authenticated,
            isLoading: false,
            user: authResult.user.username,
            clearError: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            isLoading: false,
            error: 'Failed to store authentication data',
          ),
        );
      }
    } catch (e) {
      String errorMessage;
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Registration failed: $e';
      }

      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          isLoading: false,
          error: errorMessage,
        ),
      );
    }
  }

  void _onAuthenticationUsernameUpdated(
    AuthenticationUsernameUpdated event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _authenticationService.updateUserProfile(name: event.newUsername);
      emit(state.copyWith(user: event.newUsername, clearError: true));
    } catch (_) {}
  }
}
