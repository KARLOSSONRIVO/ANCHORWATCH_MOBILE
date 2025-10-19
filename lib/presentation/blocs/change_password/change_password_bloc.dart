import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/profile/change_password_usecase.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

// Export events and states for proper BLoC architecture
export 'change_password_event.dart';
export 'change_password_state.dart';

@injectable
class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordBloc(this._changePasswordUseCase)
    : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
    on<ChangePasswordValidationRequested>(_onChangePasswordValidationRequested);
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    // Validate before submitting
    final validationResult = _validatePasswords(
      event.oldPassword,
      event.newPassword,
      event.confirmPassword,
    );

    if (!validationResult['isValid']) {
      emit(
        ChangePasswordValidationState(
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword,
          isOldPasswordValid: validationResult['isOldPasswordValid'],
          isNewPasswordValid: validationResult['isNewPasswordValid'],
          isConfirmPasswordValid: validationResult['isConfirmPasswordValid'],
          oldPasswordError: validationResult['oldPasswordError'],
          newPasswordError: validationResult['newPasswordError'],
          confirmPasswordError: validationResult['confirmPasswordError'],
          hasInteractedWithOldPassword: true,
          hasInteractedWithNewPassword: true,
          hasInteractedWithConfirmPassword: true,
        ),
      );
      return;
    }

    emit(ChangePasswordLoading());

    try {
      final result = await _changePasswordUseCase.execute(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );

      if (result.success) {
        emit(ChangePasswordSuccess(result));
      } else {
        emit(ChangePasswordFailure(result.error ?? 'Change password failed'));
      }
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }

  void _onChangePasswordValidationRequested(
    ChangePasswordValidationRequested event,
    Emitter<ChangePasswordState> emit,
  ) {
    final validationResult = _validatePasswords(
      event.oldPassword,
      event.newPassword,
      event.confirmPassword,
    );

    emit(
      ChangePasswordValidationState(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
        isOldPasswordValid: validationResult['isOldPasswordValid'],
        isNewPasswordValid: validationResult['isNewPasswordValid'],
        isConfirmPasswordValid: validationResult['isConfirmPasswordValid'],
        oldPasswordError: validationResult['oldPasswordError'],
        newPasswordError: validationResult['newPasswordError'],
        confirmPasswordError: validationResult['confirmPasswordError'],
        hasInteractedWithOldPassword: event.hasInteractedWithOldPassword,
        hasInteractedWithNewPassword: event.hasInteractedWithNewPassword,
        hasInteractedWithConfirmPassword:
            event.hasInteractedWithConfirmPassword,
      ),
    );
  }

  Map<String, dynamic> _validatePasswords(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) {
    // Validate old password
    final oldPasswordResult = _validateOldPassword(oldPassword);
    final isOldPasswordValid = oldPasswordResult['isValid'] as bool;
    final oldPasswordError = oldPasswordResult['error'] as String?;

    // Validate new password
    final newPasswordResult = _validateNewPassword(newPassword, oldPassword);
    final isNewPasswordValid = newPasswordResult['isValid'] as bool;
    final newPasswordError = newPasswordResult['error'] as String?;

    // Validate confirm password
    final confirmPasswordResult = _validateConfirmPassword(
      confirmPassword,
      newPassword,
    );
    final isConfirmPasswordValid = confirmPasswordResult['isValid'] as bool;
    final confirmPasswordError = confirmPasswordResult['error'] as String?;

    final isValid =
        isOldPasswordValid && isNewPasswordValid && isConfirmPasswordValid;

    return {
      'isValid': isValid,
      'isOldPasswordValid': isOldPasswordValid,
      'isNewPasswordValid': isNewPasswordValid,
      'isConfirmPasswordValid': isConfirmPasswordValid,
      'oldPasswordError': oldPasswordError,
      'newPasswordError': newPasswordError,
      'confirmPasswordError': confirmPasswordError,
    };
  }

  Map<String, dynamic> _validateOldPassword(String oldPassword) {
    if (oldPassword.trim().isEmpty) {
      return {'isValid': false, 'error': 'Please enter your current password'};
    }
    return {'isValid': true, 'error': null};
  }

  Map<String, dynamic> _validateNewPassword(
    String newPassword,
    String oldPassword,
  ) {
    if (newPassword.trim().isEmpty) {
      return {'isValid': false, 'error': 'Please enter a new password'};
    }

    if (newPassword.length < 8) {
      return {
        'isValid': false,
        'error': 'Password must be at least 8 characters long',
      };
    }

    if (!RegExp(r'[A-Z]').hasMatch(newPassword)) {
      return {
        'isValid': false,
        'error': 'Password must contain at least one capital letter',
      };
    }

    if (!RegExp(r'[0-9]').hasMatch(newPassword)) {
      return {
        'isValid': false,
        'error': 'Password must contain at least one number',
      };
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(newPassword)) {
      return {
        'isValid': false,
        'error': 'Password must contain at least one special character',
      };
    }

    // Check if new password is different from old password
    if (newPassword == oldPassword.trim()) {
      return {
        'isValid': false,
        'error': 'New password must be different from current password',
      };
    }

    return {'isValid': true, 'error': null};
  }

  Map<String, dynamic> _validateConfirmPassword(
    String confirmPassword,
    String newPassword,
  ) {
    if (confirmPassword.trim().isEmpty) {
      return {'isValid': false, 'error': 'Please confirm your password'};
    }

    if (confirmPassword != newPassword) {
      return {'isValid': false, 'error': 'Passwords do not match'};
    }

    return {'isValid': true, 'error': null};
  }
}
