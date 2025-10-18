import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../services/authentication_service.dart';
import '../../../services/dio_client.dart';
import 'signup_event.dart';
import 'signup_state.dart';
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
  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final validationResult = _validatePasswordWithDetails(event.password);
    final isValid = validationResult['isValid'] as bool;
    final errorMessage = validationResult['error'] as String?;
    
    final passwordsMatch = event.password == state.confirmPassword;
    
    final updatedErrors = Map<String, String>.from(state.validationErrors);
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
  void _onConfirmPasswordChanged(
    SignUpConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final isValid = event.confirmPassword.isNotEmpty;
    final passwordsMatch = state.password == event.confirmPassword;
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
  void _onFormSubmitted(
    SignUpFormSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (!state.isFormValid) {
      final errorMessage = _getFirstValidationError();
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
  bool _validateUsername(String username) {
    return username.isNotEmpty && username.length >= 3;
  }
  bool _validateEmail(String email) {
    return email.isNotEmpty && 
           email.contains('@') && 
           email.contains('.') &&
           RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
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
    
    return 'Please fill in all required fields correctly';
  }
}
