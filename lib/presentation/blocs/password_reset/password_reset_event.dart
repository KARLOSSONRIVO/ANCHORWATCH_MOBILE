import 'package:equatable/equatable.dart';

/// Events for password reset flow
abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request password reset via email
class PasswordResetEmailRequested extends PasswordResetEvent {
  const PasswordResetEmailRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Event to verify OTP code
class PasswordResetOtpVerified extends PasswordResetEvent {
  const PasswordResetOtpVerified({required this.otpCode});

  final String otpCode;

  @override
  List<Object?> get props => [otpCode];
}

/// Event to confirm new password
class PasswordResetConfirmed extends PasswordResetEvent {
  const PasswordResetConfirmed({
    required this.newPassword,
    required this.confirmPassword,
  });

  final String newPassword;
  final String confirmPassword;

  @override
  List<Object?> get props => [newPassword, confirmPassword];
}

/// Event to resend OTP
class PasswordResetOtpResendRequested extends PasswordResetEvent {
  const PasswordResetOtpResendRequested();
}

/// Event to navigate to next step
class PasswordResetNextStep extends PasswordResetEvent {
  const PasswordResetNextStep();
}

/// Event to navigate to previous step
class PasswordResetPreviousStep extends PasswordResetEvent {
  const PasswordResetPreviousStep();
}

/// Event to reset the entire flow
class PasswordResetFlowReset extends PasswordResetEvent {
  const PasswordResetFlowReset();
}

/// Event for form validation
class PasswordResetEmailChanged extends PasswordResetEvent {
  const PasswordResetEmailChanged({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Event for OTP input change
class PasswordResetOtpChanged extends PasswordResetEvent {
  const PasswordResetOtpChanged({required this.otp});

  final String otp;

  @override
  List<Object?> get props => [otp];
}

/// Event for new password input change
class PasswordResetNewPasswordChanged extends PasswordResetEvent {
  const PasswordResetNewPasswordChanged({required this.password});

  final String password;

  @override
  List<Object?> get props => [password];
}

/// Event for confirm password input change
class PasswordResetConfirmPasswordChanged extends PasswordResetEvent {
  const PasswordResetConfirmPasswordChanged({required this.confirmPassword});

  final String confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}
