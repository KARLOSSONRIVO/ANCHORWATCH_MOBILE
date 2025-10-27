import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/change_username/change_username.dart';
import '../../blocs/authentication/authentication.dart';
import '../../widgets/custom_snackbar.dart';
import '../../themes/app_theme.dart';
import '../../../injection_container.dart';
import '../../widgets/loading_widget.dart';

class ChangeUsernameScreen extends StatelessWidget {
  const ChangeUsernameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DI.get<ChangeUsernameBloc>(),
      child: const _ChangeUsernameView(),
    );
  }
}

class _ChangeUsernameView extends StatefulWidget {
  const _ChangeUsernameView();

  @override
  State<_ChangeUsernameView> createState() => _ChangeUsernameViewState();
}

class _ChangeUsernameViewState extends State<_ChangeUsernameView> {
  final _newUsernameController = TextEditingController();

  @override
  void dispose() {
    _newUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppTheme.getSurfaceColor(context),
        foregroundColor: AppTheme.getTextPrimaryColor(context),
        title: Text(
          'Change Username',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: AppTheme.getTextPrimaryColor(context),
          ),
        ),
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChangeUsernameBloc, ChangeUsernameState>(
            listener: (context, state) {
              if (state is ChangeUsernameSuccess) {
                SnackBarHelper.showSuccess(
                  context,
                  "username changed successfully",
                  duration: const Duration(milliseconds: 1500),
                );
                final newUsername = state.newUsername;
                context.read<AuthenticationBloc>().add(
                  AuthenticationUsernameUpdated(newUsername: newUsername),
                );
                Navigator.of(context).pop(newUsername);
              } else if (state is ChangeUsernameFailure) {
                SnackBarHelper.showError(context, state.error);
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/LOGOnoBG.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  'Change Your Username',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: AppTheme.getTextPrimaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Enter a new username for your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.getTextSecondaryColor(context),
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'New Username',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getTextPrimaryColor(context),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<ChangeUsernameBloc, ChangeUsernameState>(
                builder: (context, state) {
                  String? errorText;
                  if (state is ChangeUsernameValidationState &&
                      !state.isValid) {
                    errorText = state.validationError;
                  }

                  return TextFormField(
                    controller: _newUsernameController,
                    style: TextStyle(
                      color: AppTheme.getTextPrimaryColor(context),
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.getCardBackgroundColor(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
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
                      hintText: 'Enter new username',
                      hintStyle: TextStyle(
                        color: AppTheme.getTextSecondaryColor(context),
                        fontFamily: 'Inter',
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppTheme.getTextSecondaryColor(context),
                      ),
                      errorText: errorText,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      context.read<ChangeUsernameBloc>().add(
                        ChangeUsernameValidationRequested(newUsername: value),
                      );
                    },
                    onFieldSubmitted: (_) => _onSubmit(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Username can only contain letters, numbers, and underscores. It must be 3-30 characters long.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<ChangeUsernameBloc, ChangeUsernameState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is ChangeUsernameLoading
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
                      child: state is ChangeUsernameLoading
                          ? const SimpleLoadingWidget(
                              size: 20,
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text(
                              'Change Username',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    context.read<ChangeUsernameBloc>().add(
      ChangeUsernameSubmitted(newUsername: _newUsernameController.text.trim()),
    );
  }
}
