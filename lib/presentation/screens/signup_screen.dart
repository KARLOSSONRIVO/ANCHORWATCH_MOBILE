import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../blocs/signup/signup.dart';
import '../widgets/widgets.dart';
import '../themes/app_theme.dart';

/// Sign up screen for new user registration using SignUpBloc
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
      // Only trigger BLoC if basic form validation passes
      context.read<SignUpBloc>().add(const SignUpFormSubmitted());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if keyboard is visible
    _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    // Set theme-aware system UI overlay
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: AppTheme.getBackgroundColor(context),
        systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );

    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          // Trigger authentication success
          context.read<AuthenticationBloc>().add(
            AuthenticationStatusRequested(),
          );
          SnackBarHelper.showSuccess(context, 'Account created successfully!');
          Navigator.pop(context); // Go back to login
        } else if (state.hasError) {
          // Show customized toast for validation errors with shorter duration
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
                // Main content
                SingleChildScrollView(
                  physics: _isKeyboardVisible 
                      ? const AlwaysScrollableScrollPhysics() 
                      : const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back Button
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
                        
                        // Logo
                        Image.asset(
                          'assets/images/LOGOnoBG.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                        
                        // Title
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
                        
                        // Subtitle
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
                        
                        // Username Field
                        TextFormField(
                          controller: _usernameController,
                          style: TextStyle(
                            color: AppTheme.getTextPrimaryColor(context),
                            fontFamily: 'Inter',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: AppTheme.getTextSecondaryColor(context),
                              fontFamily: 'Inter',
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: AppTheme.getBorderColor(context)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppTheme.primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            prefixIcon: Icon(Icons.person, color: AppTheme.getTextSecondaryColor(context)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                          onChanged: (username) {
                            context.read<SignUpBloc>().add(
                              SignUpUsernameChanged(username: username),
                            );
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        
                        // Email Field
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
                              color: AppTheme.getTextSecondaryColor(context),
                              fontFamily: 'Inter',
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: AppTheme.getBorderColor(context)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppTheme.primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            prefixIcon: Icon(Icons.email, color: AppTheme.getTextSecondaryColor(context)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onChanged: (email) {
                            context.read<SignUpBloc>().add(
                              SignUpEmailChanged(email: email),
                            );
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        
                        // Password Field
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
                              color: AppTheme.getTextSecondaryColor(context),
                              fontFamily: 'Inter',
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: AppTheme.getBorderColor(context)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppTheme.primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            prefixIcon: Icon(Icons.lock, color: AppTheme.getTextSecondaryColor(context)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: AppTheme.getTextSecondaryColor(context),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            // Only show mismatch error if confirm password is filled and doesn't match
                            if (_confirmPasswordController.text.isNotEmpty && 
                                value != _confirmPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onChanged: (password) {
                            // Trigger BLoC password validation
                            context.read<SignUpBloc>().add(
                              SignUpPasswordChanged(password: password),
                            );
                            // Re-validate confirm password field when password changes
                            if (_confirmPasswordController.text.isNotEmpty) {
                              _formKey.currentState!.validate();
                            }
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        
                        // Confirm Password Field
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
                              color: AppTheme.getTextSecondaryColor(context),
                              fontFamily: 'Inter',
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: AppTheme.getBorderColor(context)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppTheme.primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            prefixIcon: Icon(Icons.lock, color: AppTheme.getTextSecondaryColor(context)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                color: AppTheme.getTextSecondaryColor(context),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onChanged: (confirmPassword) {
                            // Trigger BLoC confirm password validation
                            context.read<SignUpBloc>().add(
                              SignUpConfirmPasswordChanged(confirmPassword: confirmPassword),
                            );
                            // Re-validate password field when confirm password changes
                            if (_passwordController.text.isNotEmpty) {
                              _formKey.currentState!.validate();
                            }
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleSignUp(),
                        ),
                        const SizedBox(height: 32),
                        
                        // Create Account Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleSignUp,
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
                        
                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: AppTheme.getTextSecondaryColor(context),
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
                
                // Loading Overlay
                if (isLoading)
                  Container(
                    color: AppTheme.getBackgroundColor(context).withOpacity(0.7),
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