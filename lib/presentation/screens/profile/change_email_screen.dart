import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/change_email/change_email.dart';
import '../../widgets/custom_snackbar.dart';
import '../../../injection_container.dart';
import 'confirm_change_email_screen.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangeEmailBloc>(),
      child: const _ChangeEmailView(),
    );
  }
}

class _ChangeEmailView extends StatefulWidget {
  const _ChangeEmailView();

  @override
  State<_ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<_ChangeEmailView> {
  final _emailController = TextEditingController();
  bool _hasInteractedWithEmail = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeEmailBloc, ChangeEmailState>(
      listenWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      listener: (context, state) {
        if (state is ChangeEmailRequestSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConfirmChangeEmailScreen(
                    newEmail: _emailController.text.trim(),
                  ),
                ),
              ).then((result) {
                if (result != null && result.isNotEmpty && context.mounted) {
                  Navigator.pop(context, result); // bubble new email upward
                }
              });
            }
          });
        } else if (state is ChangeEmailRequestFailure) {
          SnackBarHelper.showError(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFF8F8F8) // Softer off-white for light mode
              : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
          appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFF8F8F8) // Softer off-white for light mode
                : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
            elevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          ),
          body: SingleChildScrollView(
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
                  'Change Email',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your new email address',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'New Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                BlocBuilder<ChangeEmailBloc, ChangeEmailState>(
                  builder: (context, state) {
                    String? errorText;
                    if (state is ChangeEmailValidationState &&
                        !state.isValid &&
                        state.hasInteractedWithEmail) {
                      errorText = state.validationError;
                    }

                    return TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _hasInteractedWithEmail = true;
                        _triggerValidation();
                      },
                      decoration:
                          InputDecoration(
                            hintText: 'Enter new email',
                            hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withValues(alpha: 0.5),
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
                              borderSide: BorderSide(
                                color: const Color(0xFF00E5CC),
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
                          ).copyWith(
                            errorText: errorText,
                            errorStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state is ChangeEmailRequestLoading
                        ? null
                        : _onSendOtp,
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
                    child: state is ChangeEmailRequestLoading
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
                            'Send OTP',
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
        );
      },
    );
  }

  void _triggerValidation() {
    context.read<ChangeEmailBloc>().add(
      ChangeEmailValidationRequested(
        newEmail: _emailController.text.trim(),
        hasInteractedWithEmail: _hasInteractedWithEmail,
      ),
    );
  }

  void _onSendOtp() {
    // Mark field as interacted with so validation errors will show
    _hasInteractedWithEmail = true;

    // Trigger validation first to show any errors
    _triggerValidation();

    // Then submit after a short delay to allow validation to complete
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        context.read<ChangeEmailBloc>().add(
          RequestChangeEmailSubmitted(newEmail: _emailController.text.trim()),
        );
      }
    });
  }
}
