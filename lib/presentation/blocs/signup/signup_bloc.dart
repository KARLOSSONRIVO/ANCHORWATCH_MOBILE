import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../services/authentication_service.dart';
import '../../../services/dio_client.dart';
import 'signup_event.dart';
import 'signup_state.dart';

/// BLoC for handling signup form validation and submission
@injectable
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final RegisterUseCase _registerUseCase;
  final AuthenticationService _authenticationService;

  SignUpBloc(
    this._registerUseCase,
    this._authenticationService,
  ) : super(const SignUpState()) {
    on<SignUpUsernameChanged>(_onUsernameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpFormSubmitted>(_onFormSubmitted);
    on<SignUpValidationReset>(_onValidationReset);
  }

  /// Handle username input change
  void _onUsernameChanged(
    SignUpUsernameChanged event,
    Emitter<SignUpState> emit,
  ) {
    final isValid = _validateUsername(event.username);
    emit(state.copyWith(
      username: event.username,
      isUsernameValid: isValid,
      errorMessage: null,
      clearLastShownError: true, // Clear last shown error when user makes changes
      isSubmissionError: false,
    ));
  }

  /// Handle email input change
  void _onEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    final isValid = _validateEmail(event.email);
    emit(state.copyWith(
      email: event.email,
      isEmailValid: isValid,
      errorMessage: null,
      clearLastShownError: true, // Clear last shown error when user makes changes
      isSubmissionError: false,
    ));
  }

  /// Handle password input change
  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final validationResult = _validatePasswordWithDetails(event.password);
    final isValid = validationResult['isValid'] as bool;
    final errorMessage = validationResult['error'] as String?;
    
    final passwordsMatch = event.password == state.confirmPassword;
    
    final updatedErrors = Map<String, String>.from(state.validationErrors);
    
    // Only store password validation error if passwords don't match or confirm password is empty
    // This way we show toast only when passwords match but validation fails
    if (errorMessage != null && (state.confirmPassword.isEmpty || passwordsMatch)) {
      updatedErrors['password'] = errorMessage;
    } else {
      updatedErrors.remove('password');
    }
    
    emit(state.copyWith(
      password: event.password,
      isPasswordValid: isValid,
      passwordsMatch: passwordsMatch,
      validationErrors: updatedErrors,
      errorMessage: null,
      clearLastShownError: true, // Clear last shown error when user makes changes
      isSubmissionError: false,
    ));
  }

  /// Handle confirm password input change
  void _onConfirmPasswordChanged(
    SignUpConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final isValid = event.confirmPassword.isNotEmpty;
    final passwordsMatch = state.password == event.confirmPassword;
    
    // Re-validate password with detailed validation when passwords match
    final updatedErrors = Map<String, String>.from(state.validationErrors);
    if (passwordsMatch && state.password.isNotEmpty) {
      final validationResult = _validatePasswordWithDetails(state.password);
      final passwordValid = validationResult['isValid'] as bool;
      final passwordError = validationResult['error'] as String?;
      
      if (passwordError != null && !passwordValid) {
        updatedErrors['password'] = passwordError;
      } else {
        updatedErrors.remove('password');
      }
    } else {
      // Remove password errors when passwords don't match
      updatedErrors.remove('password');
    }
    
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      isConfirmPasswordValid: isValid,
      passwordsMatch: passwordsMatch,
      validationErrors: updatedErrors,
      errorMessage: null,
      clearLastShownError: true, // Clear last shown error when user makes changes
      isSubmissionError: false,
    ));
  }

  /// Handle form submission
  void _onFormSubmitted(
    SignUpFormSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (!state.isFormValid) {
      // Generate validation error to show in snackbar
      final errorMessage = _getFirstValidationError();
      
      // Only emit error if it's different from the last shown error
      if (errorMessage != state.lastShownError) {
        emit(state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: errorMessage,
          lastShownError: errorMessage,
          isSubmissionError: true, // Mark as submission error for toast
        ));
      }
      return;
    }

    emit(state.copyWith(status: SignUpStatus.loading));

    try {
      final authResult = await _registerUseCase(
        username: state.username,
        email: state.email,
        password: state.password,
      );

      final stored = await _authenticationService.storeAuthResult(authResult);
      
      if (stored) {
        emit(state.copyWith(status: SignUpStatus.success));
      } else {
        emit(state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: 'Failed to store authentication data',
          isSubmissionError: true,
        ));
      }
    } catch (e) {
      String errorMessage;
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Registration failed: $e';
      }
      
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: errorMessage,
        isSubmissionError: true,
      ));
    }
  }

  /// Handle validation reset
  void _onValidationReset(
    SignUpValidationReset event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      status: SignUpStatus.initial,
      errorMessage: null,
      validationErrors: {},
    ));
  }

  /// Validate username
  bool _validateUsername(String username) {
    return username.isNotEmpty && username.length >= 3;
  }

  /// Validate email format
  bool _validateEmail(String email) {
    return email.isNotEmpty && 
           email.contains('@') && 
           email.contains('.') &&
           RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password with detailed error messages
  Map<String, dynamic> _validatePasswordWithDetails(String password) {
    if (password.isEmpty) {
      return {'isValid': false, 'error': 'Please enter your password'};
    }

    if (password.length < 8) {
      return {'isValid': false, 'error': 'Password must be at least 8 characters long'};
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return {'isValid': false, 'error': 'Password must contain at least one capital letter'};
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return {'isValid': false, 'error': 'Password must contain at least one number'};
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return {'isValid': false, 'error': 'Password must contain at least one special character'};
    }

    return {'isValid': true, 'error': null};
  }

  /// Get the first validation error for snackbar display
  /// NOTE: Excludes "Passwords do not match" - that should only show as inline text
  String _getFirstValidationError() {
    if (!state.isUsernameValid) {
      return 'Please enter a valid username (at least 3 characters)';
    }
    
    if (!state.isEmailValid) {
      return 'Please enter a valid email address';
    }
    
    if (!state.isPasswordValid && state.validationErrors['password'] != null) {
      return state.validationErrors['password']!;
    }
    
    // Do NOT show toast for password mismatch - only inline validation
    // if (!state.passwordsMatch) {
    //   return 'Passwords do not match';
    // }
    
    return 'Please fill in all required fields correctly';
  }
}