import 'package:equatable/equatable.dart';
abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object?> get props => [];
}
class PasswordResetEmailRequested extends PasswordResetEvent {
  const PasswordResetEmailRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
class PasswordResetOtpVerified extends PasswordResetEvent {
  const PasswordResetOtpVerified({required this.otpCode});

  final String otpCode;

  @override
  List<Object?> get props => [otpCode];
}
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
class PasswordResetOtpResendRequested extends PasswordResetEvent {
  const PasswordResetOtpResendRequested();
}
class PasswordResetNextStep extends PasswordResetEvent {
  const PasswordResetNextStep();
}
class PasswordResetPreviousStep extends PasswordResetEvent {
  const PasswordResetPreviousStep();
}
class PasswordResetFlowReset extends PasswordResetEvent {
  const PasswordResetFlowReset();
}
class PasswordResetEmailChanged extends PasswordResetEvent {
  const PasswordResetEmailChanged({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
class PasswordResetOtpChanged extends PasswordResetEvent {
  const PasswordResetOtpChanged({required this.otp});

  final String otp;

  @override
  List<Object?> get props => [otp];
}
class PasswordResetNewPasswordChanged extends PasswordResetEvent {
  const PasswordResetNewPasswordChanged({required this.password});

  final String password;

  @override
  List<Object?> get props => [password];
}
class PasswordResetConfirmPasswordChanged extends PasswordResetEvent {
  const PasswordResetConfirmPasswordChanged({required this.confirmPassword});

  final String confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}

