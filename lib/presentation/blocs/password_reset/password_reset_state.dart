import 'package:equatable/equatable.dart';
enum PasswordResetStatus {
  initial,
  loading,
  emailSent,
  otpVerified,
  passwordReset,
  failure,
}
enum PasswordResetStep {
  email,
  otp,
  newPassword,
}
class PasswordResetState extends Equatable {
  const PasswordResetState({
    this.status = PasswordResetStatus.initial,
    this.step = PasswordResetStep.email,
    this.email = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.errorMessage,
    this.isEmailValid = false,
    this.isOtpValid = false,
    this.isNewPasswordValid = false,
    this.isConfirmPasswordValid = false,
    this.passwordsMatch = false,
    this.canResendOtp = true,
    this.otpResendCooldown = 0,
  });

  final PasswordResetStatus status;
  final PasswordResetStep step;
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final String? errorMessage;
  final bool isEmailValid;
  final bool isOtpValid;
  final bool isNewPasswordValid;
  final bool isConfirmPasswordValid;
  final bool passwordsMatch;
  final bool canResendOtp;
  final int otpResendCooldown;
  bool get isCurrentStepValid {
    switch (step) {
      case PasswordResetStep.email:
        return isEmailValid;
      case PasswordResetStep.otp:
        return isOtpValid;
      case PasswordResetStep.newPassword:
        return isNewPasswordValid && isConfirmPasswordValid && passwordsMatch;
    }
  }
  bool get isLoading => status == PasswordResetStatus.loading;
  bool get hasError => status == PasswordResetStatus.failure && errorMessage != null;

  PasswordResetState copyWith({
    PasswordResetStatus? status,
    PasswordResetStep? step,
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    String? errorMessage,
    bool? isEmailValid,
    bool? isOtpValid,
    bool? isNewPasswordValid,
    bool? isConfirmPasswordValid,
    bool? passwordsMatch,
    bool? canResendOtp,
    int? otpResendCooldown,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      step: step ?? this.step,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isOtpValid: isOtpValid ?? this.isOtpValid,
      isNewPasswordValid: isNewPasswordValid ?? this.isNewPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      passwordsMatch: passwordsMatch ?? this.passwordsMatch,
      canResendOtp: canResendOtp ?? this.canResendOtp,
      otpResendCooldown: otpResendCooldown ?? this.otpResendCooldown,
    );
  }

  @override
  List<Object?> get props => [
        status,
        step,
        email,
        otp,
        newPassword,
        confirmPassword,
        errorMessage,
        isEmailValid,
        isOtpValid,
        isNewPasswordValid,
        isConfirmPasswordValid,
        passwordsMatch,
        canResendOtp,
        otpResendCooldown,
      ];
}

