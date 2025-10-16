import 'package:equatable/equatable.dart';

/// Status enum for signup flow
enum SignUpStatus {
  initial,
  loading,
  success,
  failure,
  validating,
}

/// State for signup form validation
class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.initial,
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.errorMessage,
    this.validationErrors = const {},
    this.isUsernameValid = false,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isConfirmPasswordValid = false,
    this.passwordsMatch = false,
    this.lastShownError,
    this.isSubmissionError = false, // Track if this is a submission error
  });

  final SignUpStatus status;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String? errorMessage;
  final Map<String, String> validationErrors;
  final bool isUsernameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool passwordsMatch;
  final String? lastShownError;
  final bool isSubmissionError; // Track if this is a submission error

  /// Check if form is valid
  bool get isFormValid => 
      isUsernameValid && 
      isEmailValid && 
      isPasswordValid && 
      isConfirmPasswordValid && 
      passwordsMatch;

  /// Check if loading
  bool get isLoading => status == SignUpStatus.loading;

  /// Check if there's an error that should show toast
  bool get hasError => status == SignUpStatus.failure && errorMessage != null && isSubmissionError;

  /// Get password validation error for display
  String? get passwordValidationError => validationErrors['password'];

  SignUpState copyWith({
    SignUpStatus? status,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? errorMessage,
    Map<String, String>? validationErrors,
    bool? isUsernameValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? passwordsMatch,
    String? lastShownError,
    bool? clearLastShownError, // Helper parameter to clear the error
    bool? isSubmissionError,
  }) {
    return SignUpState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      validationErrors: validationErrors ?? this.validationErrors,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      passwordsMatch: passwordsMatch ?? this.passwordsMatch,
      lastShownError: clearLastShownError == true ? null : (lastShownError ?? this.lastShownError),
      isSubmissionError: isSubmissionError ?? this.isSubmissionError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        username,
        email,
        password,
        confirmPassword,
        errorMessage,
        validationErrors,
        isUsernameValid,
        isEmailValid,
        isPasswordValid,
        isConfirmPasswordValid,
        passwordsMatch,
        lastShownError,
        isSubmissionError,
      ];

  @override
  String toString() => 'SignUpState(status: $status, isFormValid: $isFormValid, validationErrors: $validationErrors)';
}