import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/change_email/change_email_bloc.dart';
import '../../widgets/custom_snackbar.dart';
import '../../../injection_container.dart';
import '../../../utils/validators/form_validators.dart';

class ConfirmChangeEmailScreen extends StatelessWidget {
  final String newEmail;

  const ConfirmChangeEmailScreen({super.key, required this.newEmail});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangeEmailBloc>(),
      child: _ConfirmChangeEmailView(newEmail: newEmail),
    );
  }
}

class _ConfirmChangeEmailView extends StatefulWidget {
  final String newEmail;

  const _ConfirmChangeEmailView({required this.newEmail});

  @override
  State<_ConfirmChangeEmailView> createState() =>
      _ConfirmChangeEmailViewState();
}

class _ConfirmChangeEmailViewState extends State<_ConfirmChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeEmailBloc, ChangeEmailState>(
      listenWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      listener: (context, state) {
        if (state is ChangeEmailConfirmSuccess) {
          FocusScope.of(context).unfocus();
          Navigator.pop(context, widget.newEmail);
        } else if (state is ChangeEmailConfirmFailure) {
          SnackBarHelper.showError(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFF8F8F8) // Softer off-white for light mode
              : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Image.asset(
                      'assets/images/LOGOnoBG.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Confirm Email',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.newEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'OTP Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _otpController,
                      validator: FormValidators.validateOtp,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
                        hintStyle: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                          fontFamily: 'Inter',
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF00E5CC),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state is ChangeEmailConfirmLoading
                            ? null
                            : _onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF00E5CC,
                          ), // Consistent with app branding
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          disabledBackgroundColor: const Color(
                            0xFF00E5CC,
                          ).withValues(alpha: 0.5),
                        ),
                        child: state is ChangeEmailConfirmLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onConfirm() {
    if (_formKey.currentState?.validate() == true) {
      context.read<ChangeEmailBloc>().add(
        ConfirmChangeEmailSubmitted(
          otp: _otpController.text.trim(),
          newEmail: widget.newEmail,
        ),
      );
    }
  }
}

