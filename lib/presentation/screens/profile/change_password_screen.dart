import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/change_password/change_password_bloc.dart';
import '../../widgets/custom_snackbar.dart';
import '../../../injection_container.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DI.get<ChangePasswordBloc>(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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
        if (state is ChangePasswordSuccess) {
          SnackBarHelper.showSuccess(context, 'Password changed successfully!');
          Navigator.of(context).pop();
        } else if (state is ChangePasswordFailure) {
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
          body: Stack(
            children: [
              SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Image.asset('assets/images/LOGOnoBG.png', width: 200, height: 200),
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
                  
                  // Current Password Field
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
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: _obscureOldPassword,
                    validator: _validateCurrentPassword,
                    decoration: _buildPasswordInputDecoration(
                      'Enter current password',
                      _obscureOldPassword,
                      () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // New Password Field
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
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    validator: _validateNewPassword,
                    decoration: _buildPasswordInputDecoration(
                      'Enter new password',
                      _obscureNewPassword,
                      () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirm Password Field
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
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                    decoration: _buildPasswordInputDecoration(
                      'Confirm new password',
                      _obscureConfirmPassword,
                      () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is ChangePasswordLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5CC), // Consistent with app branding
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        disabledBackgroundColor: const Color(0xFF00E5CC).withOpacity(0.5),
                      ),
                      child: const Text(
                        'Change Password',
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
          
          // Loading overlay
          if (state is ChangePasswordLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E5CC)),
                ),
              ),
            ),
        ],
      ),
    );
      },
    );
  }

  InputDecoration _buildPasswordInputDecoration(String hintText, bool obscureText, VoidCallback onToggle) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
        fontFamily: 'Inter',
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
        onPressed: onToggle,
      ),
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.light
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
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  String? _validateCurrentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Current password is required';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'New password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() == true) {
      context.read<ChangePasswordBloc>().add(
        ChangePasswordSubmitted(
          oldPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        ),
      );
    }
  }
}