import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../routes/routes.dart';
import '../widgets/widgets.dart';
import '../themes/app_theme.dart';
import '../../utils/validators/form_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationBloc>().add(
        AuthenticationLoginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(context),
      body: SafeArea(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.status == AuthenticationStatus.loading) {
              if (mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
              }
            } else if (state.status == AuthenticationStatus.authenticated) {
              if (mounted) {
                // Reset navigation stack to ensure clean state
                context.read<NavigationBloc>().add(const NavigationReset());

                // Show login success snackbar
                SnackBarHelper.showSuccess(context, "Login successful!");

                // Then navigate after a short delay to let snackbar show
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    Future.delayed(const Duration(milliseconds: 1500), () {
                      if (mounted) {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.dashboard);
                      }
                    });
                  }
                });
              }
            } else if (state.status == AuthenticationStatus.unauthenticated &&
                state.error != null) {
              if (mounted) {
                SnackBarHelper.showError(context, state.error!);
              }
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              final isLoading =
                  state.status == AuthenticationStatus.loading ||
                  state.isLoading;

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 40.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
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
                              'Log in',
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
                              ),
                              decoration: InputDecoration(
                                hintText: 'Username or Email',
                                hintStyle: TextStyle(
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                  fontFamily: 'Inter',
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.getBorderColor(context),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.getBorderColor(context),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              validator: FormValidators.validateUsernameOrEmail,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(
                                color: AppTheme.getTextPrimaryColor(context),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: AppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                  fontFamily: 'Inter',
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.getBorderColor(context),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.getBorderColor(context),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
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
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) =>
                                  FormValidators.validateRequired(
                                    value,
                                    'password',
                                  ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleLogin(),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.resetPasswordEmail,
                                  );
                                },
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: AppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
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
                                  'Log in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: AppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                          text: 'Signing in...',
                          textStyle: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
