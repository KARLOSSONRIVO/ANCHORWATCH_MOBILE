import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/password_reset/password_reset.dart';
import '../../themes/app_theme.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/loading_widget.dart';
class ResetPasswordOtpScreen extends StatefulWidget {
  const ResetPasswordOtpScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ResetPasswordOtpScreen> createState() => _ResetPasswordOtpScreenState();
}

class _ResetPasswordOtpScreenState extends State<ResetPasswordOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
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
            context.read<PasswordResetBloc>().add(const PasswordResetPreviousStep());
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<PasswordResetBloc, PasswordResetState>(
        listener: (context, state) {
          if (state.status == PasswordResetStatus.otpVerified) {
            Navigator.of(context).pushReplacementNamed('/reset-password/confirm');
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
                      Icons.mail_outline,
                      size: 50,
                      color: AppTheme.getTextPrimaryColor(context),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextPrimaryColor(context),
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.getTextSecondaryColor(context),
                        fontFamily: 'Inter',
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: 'We\'ve sent a 6-digit verification code to\n'),
                        TextSpan(
                          text: widget.email,
                          style: TextStyle(
                            color: AppTheme.getTextPrimaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OTP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.getTextPrimaryColor(context),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 50,
                            height: 60,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.getTextPrimaryColor(context),
                                fontFamily: 'Inter',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 5) {
                                    _otpFocusNodes[index + 1].requestFocus();
                                  } else {
                                    _otpFocusNodes[index].unfocus();
                                  }
                                } else if (value.isEmpty && index > 0) {
                                  _otpFocusNodes[index - 1].requestFocus();
                                }
                                final otp = _otpControllers
                                    .map((controller) => controller.text)
                                    .join();
                                context.read<PasswordResetBloc>().add(
                                  PasswordResetOtpChanged(otp: otp),
                                );
                              },
                              decoration: InputDecoration(
                                counterText: '',
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
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          );
                        }),
                      ),
                      if (!state.isOtpValid && state.otp.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Please enter a valid 6-digit OTP',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade400,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  if (state.canResendOtp)
                    TextButton(
                      onPressed: () {
                        context.read<PasswordResetBloc>().add(
                          const PasswordResetOtpResendRequested(),
                        );
                      },
                      child: Text(
                        'Didn\'t receive the code? Resend OTP',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF00BCD4),
                          fontFamily: 'Inter',
                        ),
                      ),
                    )
                  else
                    Text(
                      'Resend OTP in ${state.otpResendCooldown}s',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.getTextSecondaryColor(context),
                        fontFamily: 'Inter',
                      ),
                    ),
                  
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isOtpValid && !state.isLoading
                          ? () => _verifyOtp(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isOtpValid
                            ? const Color(0xFF00BCD4)
                            : AppTheme.getBorderColor(context),
                        foregroundColor: state.isOtpValid
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
                              'Verify OTP',
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

  void _verifyOtp(BuildContext context) {
    final otp = _otpControllers.map((controller) => controller.text).join();
    context.read<PasswordResetBloc>().add(
      PasswordResetOtpVerified(otpCode: otp),
    );
  }
}
