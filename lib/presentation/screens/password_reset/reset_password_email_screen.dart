import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/password_reset/password_reset.dart';
import '../../routes/app_router.dart';
import '../../themes/app_theme.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/loading_widget.dart';

/// Screen for entering email to reset password
class ResetPasswordEmailScreen extends StatefulWidget {
  const ResetPasswordEmailScreen({super.key});

  @override
  State<ResetPasswordEmailScreen> createState() => _ResetPasswordEmailScreenState();
}

class _ResetPasswordEmailScreenState extends State<ResetPasswordEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
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
          icon: Icon(Icons.arrow_back, color: AppTheme.getTextPrimaryColor(context)),
          onPressed: () {
            AppRouter.clearPasswordResetBloc();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<PasswordResetBloc, PasswordResetState>(
        listener: (context, state) {
          if (state.status == PasswordResetStatus.emailSent) {
            // Navigate to OTP screen
            Navigator.of(context).pushReplacementNamed(
              '/reset-password/otp',
              arguments: state.email,
            );
          }
          
          if (state.hasError) {
            SnackBarHelper.showError(
              context,
              state.errorMessage!,
            );
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
                  
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00BCD4),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BCD4).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      size: 50,
                      color: AppTheme.getTextPrimaryColor(context),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextPrimaryColor(context),
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  Text(
                    'Enter your email address and we\'ll send you a verification code to reset your password.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.getTextSecondaryColor(context),
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Email Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.getTextPrimaryColor(context),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: AppTheme.getTextPrimaryColor(context),
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          context.read<PasswordResetBloc>().add(
                            PasswordResetEmailChanged(email: value),
                          );
                        },
                        onSubmitted: (_) {
                          if (state.isEmailValid && !state.isLoading) {
                            _sendResetEmail(context);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your email address',
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
                            Icons.email_outlined,
                            color: AppTheme.getTextSecondaryColor(context),
                          ),
                        ),
                      ),
                      if (!state.isEmailValid && state.email.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Please enter a valid email address',
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
                  
                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isEmailValid && !state.isLoading
                          ? () => _sendResetEmail(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isEmailValid
                            ? const Color(0xFF00BCD4)
                            : AppTheme.getBorderColor(context),
                        foregroundColor: state.isEmailValid
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
                              'Send OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
              
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _sendResetEmail(BuildContext context) {
    _emailFocusNode.unfocus();
    context.read<PasswordResetBloc>().add(
      PasswordResetEmailRequested(email: _emailController.text.trim()),
    );
  }
}