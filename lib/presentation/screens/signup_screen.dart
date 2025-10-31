import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../blocs/signup/signup.dart';
import '../widgets/widgets.dart';
import '../themes/app_theme.dart';
import '../../utils/validators/form_validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isKeyboardVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<SignUpBloc>().add(const SignUpFormSubmitted());
    }
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: AppTheme.getBackgroundColor(context),
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          context.read<AuthenticationBloc>().add(
            AuthenticationStatusRequested(),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        } else if (state.hasError) {
          SnackBarHelper.showError(
            context,
            state.errorMessage!,
            duration: const Duration(seconds: 2), // Reduced from 4 to 2 seconds
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Scaffold(
          backgroundColor: AppTheme.getBackgroundColor(context),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: _isKeyboardVisible
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 32.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: AppTheme.getTextPrimaryColor(context),
                                  size: 24,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Spacer(),
                            Image.asset(
                              'assets/images/LOGOnoBG.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'Welcome to AnchorWatch',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.getTextPrimaryColor(context),
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.getTextSecondaryColor(context),
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(
                                color: AppTheme.getTextPrimaryColor(context),
                                fontFamily: 'Inter',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                  fontFamily: 'Inter',
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: AppTheme.getBorderColor(context),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                ),
                              ),
                              validator: FormValidators.validateUsername,
                              onChanged: (username) {
                                context.read<SignUpBloc>().add(
                                  SignUpUsernameChanged(username: username),
                                );
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: AppTheme.getTextPrimaryColor(context),
                                fontFamily: 'Inter',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                  fontFamily: 'Inter',
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: AppTheme.getBorderColor(context),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                ),
                              ),
                              validator: FormValidators.validateEmail,
                              onChanged: (email) {
                                context.read<SignUpBloc>().add(
                                  SignUpEmailChanged(email: email),
                                );
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(
                                color: AppTheme.getTextPrimaryColor(context),
                                fontFamily: 'Inter',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                  fontFamily: 'Inter',
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: AppTheme.getBorderColor(context),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) =>
                                  FormValidators.validatePassword(value),
                              onChanged: (password) {
                                context.read<SignUpBloc>().add(
                                  SignUpPasswordChanged(password: password),
                                );
                                if (_confirmPasswordController
                                    .text
                                    .isNotEmpty) {
                                  _formKey.currentState!.validate();
                                }
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: TextStyle(
                                color: AppTheme.getTextPrimaryColor(context),
                                fontFamily: 'Inter',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                  fontFamily: 'Inter',
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: AppTheme.getBorderColor(context),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) =>
                                  FormValidators.validateConfirmPassword(
                                    value,
                                    _passwordController.text,
                                  ),
                              onChanged: (confirmPassword) {
                                context.read<SignUpBloc>().add(
                                  SignUpConfirmPasswordChanged(
                                    confirmPassword: confirmPassword,
                                  ),
                                );
                                if (_passwordController.text.isNotEmpty) {
                                  _formKey.currentState!.validate();
                                }
                              },
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleSignUp(),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF484848),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: AppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    'Log in',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: AppTheme.getBackgroundColor(
                      context,
                    ).withValues(alpha: 0.7),
                    child: const Center(
                      child: LoadingWidget(
                        size: 48.0,
                        color: AppTheme.primaryColor,
                        strokeWidth: 3.0,
                        text: 'Creating Account...',
                        textStyle: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 16,
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
}
