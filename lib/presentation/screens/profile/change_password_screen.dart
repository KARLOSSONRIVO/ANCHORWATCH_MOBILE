import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/change_password/change_password.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/loading_widget.dart';
import '../../../injection_container.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DI.get<ChangePasswordBloc>(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _hasInteractedWithOldPassword = false;
  bool _hasInteractedWithNewPassword = false;
  bool _hasInteractedWithConfirmPassword = false;
  String? _lastShownError;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordLoading) {
          _isSubmitting = true;
          _lastShownError = null;
        } else if (state is ChangePasswordSuccess) {
          _isSubmitting = false;
          SnackBarHelper.showSuccess(context, "Password changed successfully!",duration: const Duration(milliseconds: 1500),);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        } else if (state is ChangePasswordFailure) {
          _isSubmitting = false;
          if (_lastShownError != state.error) {
            _lastShownError = state.error;
            SnackBarHelper.showError(context, state.error);
          }
        } else if (state is ChangePasswordValidationState) {
          _isSubmitting = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFF8F8F8)
              : const Color(0xFF1E1E1E),
          appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFF8F8F8)
                : const Color(0xFF1E1E1E),
            elevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/images/LOGOnoBG.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Current Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                      builder: (context, state) {
                        String? errorText;
                        if (state is ChangePasswordValidationState &&
                            !state.isOldPasswordValid &&
                            state.hasInteractedWithOldPassword) {
                          errorText = state.oldPasswordError;
                        }

                        return TextFormField(
                          controller: _oldPasswordController,
                          obscureText: _obscureOldPassword,
                          onChanged: (value) {
                            _hasInteractedWithOldPassword = true;
                            _triggerValidation();
                          },
                          decoration: _buildPasswordInputDecoration(
                            'Enter current password',
                            _obscureOldPassword,
                            () => setState(
                              () => _obscureOldPassword = !_obscureOldPassword,
                            ),
                          ).copyWith(errorText: errorText),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                      builder: (context, state) {
                        String? errorText;
                        if (state is ChangePasswordValidationState &&
                            !state.isNewPasswordValid &&
                            state.hasInteractedWithNewPassword) {
                          errorText = state.newPasswordError;
                        }

                        return TextFormField(
                          controller: _newPasswordController,
                          obscureText: _obscureNewPassword,
                          onChanged: (value) {
                            _hasInteractedWithNewPassword = true;
                            _triggerValidation();
                          },
                          decoration: _buildPasswordInputDecoration(
                            'Enter new password',
                            _obscureNewPassword,
                            () => setState(
                              () => _obscureNewPassword = !_obscureNewPassword,
                            ),
                          ).copyWith(errorText: errorText),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                      builder: (context, state) {
                        String? errorText;
                        if (state is ChangePasswordValidationState &&
                            !state.isConfirmPasswordValid &&
                            state.hasInteractedWithConfirmPassword) {
                          errorText = state.confirmPasswordError;
                        }

                        return TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          onChanged: (value) {
                            _hasInteractedWithConfirmPassword = true;
                            _triggerValidation();
                          },
                          decoration: _buildPasswordInputDecoration(
                            'Confirm new password',
                            _obscureConfirmPassword,
                            () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ).copyWith(errorText: errorText),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is ChangePasswordLoading
                            ? null
                            : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF484848),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state is ChangePasswordLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: LoadingWidget(
                      size: 48.0,
                      color: const Color(0xFF00E5CC),
                      strokeWidth: 3.0,
                      text: 'Changing password...',
                      textStyle: const TextStyle(
                        color: Color(0xFF00E5CC),
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _buildPasswordInputDecoration(
    String hintText,
    bool obscureText,
    VoidCallback onToggle,
  ) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Theme.of(
          context,
        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
        fontFamily: 'Inter',
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
        ),
        onPressed: onToggle,
      ),
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00E5CC), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _onSubmit() {
    if (_isSubmitting) return;

    _hasInteractedWithOldPassword = true;
    _hasInteractedWithNewPassword = true;
    _hasInteractedWithConfirmPassword = true;

    _triggerValidation();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        context.read<ChangePasswordBloc>().add(
          ChangePasswordSubmitted(
            oldPassword: _oldPasswordController.text.trim(),
            newPassword: _newPasswordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
          ),
        );
      }
    });
  }

  void _triggerValidation() {
    context.read<ChangePasswordBloc>().add(
      ChangePasswordValidationRequested(
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        hasInteractedWithOldPassword: _hasInteractedWithOldPassword,
        hasInteractedWithNewPassword: _hasInteractedWithNewPassword,
        hasInteractedWithConfirmPassword: _hasInteractedWithConfirmPassword,
      ),
    );
  }
}
