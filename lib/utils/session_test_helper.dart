import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/blocs/authentication/authentication.dart';
import '../presentation/widgets/session_expired_card.dart';

class SessionTestHelper {
  /// Test method to simulate session expiration
  /// This can be called from any screen for testing purposes
  static void simulateSessionExpiration(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();
    authBloc.add(const AuthenticationSessionExpired());
  }

  /// Test method to show the session expired dialog directly
  /// This can be used to test the UI without triggering the full flow
  static void showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SessionExpiredCard(),
    );
  }

  /// Test method to simulate a 401 error response
  /// This would trigger the Dio interceptor
  static void simulate401Error(BuildContext context) {
    // This would normally be triggered by a real API call that returns 401
    // For testing, we can directly trigger the session expired event
    simulateSessionExpiration(context);
  }
}
