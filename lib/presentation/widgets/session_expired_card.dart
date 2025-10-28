import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../themes/app_theme.dart';
import '../../services/dio_client.dart';

class SessionExpiredCard extends StatelessWidget {
  const SessionExpiredCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final accentColor = isLightMode
        ? AppTheme.aiSummaryColorLight
        : const Color(0xFF00D4AA);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isLightMode ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time_filled,
                size: 32,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Session Expired',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isLightMode ? Colors.black87 : Colors.white,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              'Your session has expired. Please log in again to continue using the app.',
              style: TextStyle(
                fontSize: 14,
                color: isLightMode ? Colors.grey[600] : Colors.grey[400],
                fontFamily: 'Inter',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog first

                  // Reset session expiry flag to allow login
                  DioClient.resetSessionExpiryFlag();

                  // Clear any error messages and logout
                  context.read<AuthenticationBloc>().add(
                    const AuthenticationErrorCleared(),
                  );
                  context.read<AuthenticationBloc>().add(
                    const AuthenticationLogoutRequested(),
                  );
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text(
                  'Log In Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Additional Info
            Text(
              'Your data is safe and will be restored after login.',
              style: TextStyle(
                fontSize: 12,
                color: isLightMode ? Colors.grey[500] : Colors.grey[500],
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
