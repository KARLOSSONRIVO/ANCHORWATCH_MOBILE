import 'package:equatable/equatable.dart';
import '../../../domain/entities/profile/change_password_result.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final ChangePasswordResult result;

  const ChangePasswordSuccess(this.result);

  @override
  List<Object> get props => [result];
}

class ChangePasswordFailure extends ChangePasswordState {
  final String error;

  const ChangePasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChangePasswordValidationState extends ChangePasswordState {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isOldPasswordValid;
  final bool isNewPasswordValid;
  final bool isConfirmPasswordValid;
  final String? oldPasswordError;
  final String? newPasswordError;
  final String? confirmPasswordError;
  final bool hasInteractedWithOldPassword;
  final bool hasInteractedWithNewPassword;
  final bool hasInteractedWithConfirmPassword;

  const ChangePasswordValidationState({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.isOldPasswordValid,
    required this.isNewPasswordValid,
    required this.isConfirmPasswordValid,
    this.oldPasswordError,
    this.newPasswordError,
    this.confirmPasswordError,
    this.hasInteractedWithOldPassword = false,
    this.hasInteractedWithNewPassword = false,
    this.hasInteractedWithConfirmPassword = false,
  });

  @override
  List<Object> get props => [
    oldPassword,
    newPassword,
    confirmPassword,
    isOldPasswordValid,
    isNewPasswordValid,
    isConfirmPasswordValid,
    oldPasswordError ?? '',
    newPasswordError ?? '',
    confirmPasswordError ?? '',
    hasInteractedWithOldPassword,
    hasInteractedWithNewPassword,
    hasInteractedWithConfirmPassword,
  ];
}
