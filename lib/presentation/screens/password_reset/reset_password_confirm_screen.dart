import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/password_reset/password_reset.dart';
import '../../routes/app_router.dart';
import '../../themes/app_theme.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/loading_widget.dart';

class ResetPasswordConfirmScreen extends StatefulWidget {
  const ResetPasswordConfirmScreen({super.key});

  @override
  State<ResetPasswordConfirmScreen> createState() =>
      _ResetPasswordConfirmScreenState();
}

class _ResetPasswordConfirmScreenState
    extends State<ResetPasswordConfirmScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppTheme.getBackgroundColor(context),
        foregroundColor: AppTheme.getTextPrimaryColor(context),
        title: Text(
          'Reset Password',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: AppTheme.getTextPrimaryColor(context),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.getTextPrimaryColor(context),
          ),
          onPressed: () {
            context.read<PasswordResetBloc>().add(
              const PasswordResetPreviousStep(),
            );
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<PasswordResetBloc, PasswordResetState>(
        listener: (context, state) {
          if (state.status == PasswordResetStatus.passwordReset) {
            SnackBarHelper.showSuccess(
              context,
              'Password reset successful! Please login with your new password.',
              duration: const Duration(seconds: 3),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                AppRouter.clearPasswordResetBloc();
              }
            });
          }

          if (state.hasError) {
            SnackBarHelper.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00BCD4),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 50,
                      color: AppTheme.getTextPrimaryColor(context),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Text(
                    'New Password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextPrimaryColor(context),
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'Create a new secure password for your account.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.getTextSecondaryColor(context),
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.getTextPrimaryColor(context),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _newPasswordController,
                        focusNode: _newPasswordFocusNode,
                        obscureText: !_isNewPasswordVisible,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          color: AppTheme.getTextPrimaryColor(context),
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          context.read<PasswordResetBloc>().add(
                            PasswordResetNewPasswordChanged(password: value),
                          );
                        },
                        onSubmitted: (_) {
                          _confirmPasswordFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                          hintStyle: TextStyle(
                            color: AppTheme.getTextSecondaryColor(context),
                            fontFamily: 'Inter',
                          ),
                          filled: true,
                          fillColor: AppTheme.getCardBackgroundColor(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.getBorderColor(context),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.getBorderColor(context),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF00BCD4),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppTheme.getTextSecondaryColor(context),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.getTextSecondaryColor(context),
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      if (!state.isNewPasswordValid &&
                          state.newPassword.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Password must be at least 8 characters with uppercase, lowercase and number',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade400,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm New Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.getTextPrimaryColor(context),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        obscureText: !_isConfirmPasswordVisible,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: AppTheme.getTextPrimaryColor(context),
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          context.read<PasswordResetBloc>().add(
                            PasswordResetConfirmPasswordChanged(
                              confirmPassword: value,
                            ),
                          );
                        },
                        onSubmitted: (_) {
                          if (state.isCurrentStepValid && !state.isLoading) {
                            _confirmPasswordReset(context);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                          hintStyle: TextStyle(
                            color: AppTheme.getTextSecondaryColor(context),
                            fontFamily: 'Inter',
                          ),
                          filled: true,
                          fillColor: AppTheme.getCardBackgroundColor(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.getBorderColor(context),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.getBorderColor(context),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF00BCD4),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppTheme.getTextSecondaryColor(context),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.getTextSecondaryColor(context),
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      if (!state.passwordsMatch &&
                          state.confirmPassword.isNotEmpty &&
                          state.newPassword.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Passwords do not match',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade400,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                    ],
                  ),

                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isCurrentStepValid && !state.isLoading
                          ? () => _confirmPasswordReset(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isCurrentStepValid
                            ? const Color(0xFF00BCD4)
                            : AppTheme.getBorderColor(context),
                        foregroundColor: state.isCurrentStepValid
                            ? AppTheme.getTextPrimaryColor(context)
                            : AppTheme.getTextSecondaryColor(context),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: state.isLoading
                          ? SimpleLoadingWidget(
                              size: 20,
                              color: AppTheme.getTextPrimaryColor(context),
                              strokeWidth: 2,
                            )
                          : const Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmPasswordReset(BuildContext context) {
    _newPasswordFocusNode.unfocus();
    _confirmPasswordFocusNode.unfocus();

    context.read<PasswordResetBloc>().add(
      PasswordResetConfirmed(
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }
}
