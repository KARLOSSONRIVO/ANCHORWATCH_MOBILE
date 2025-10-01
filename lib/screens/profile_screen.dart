import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../routes/routes.dart';

/// Profile screen to show user information
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Header
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue.shade700,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.user ?? 'User',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AnchorWatch User',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Profile Options
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _ProfileOption(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          NavigationHelper.showMessage(
                            context, 
                            'Settings screen coming soon!'
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _ProfileOption(
                        icon: Icons.anchor,
                        title: 'Anchor History',
                        onTap: () {
                          NavigationHelper.showMessage(
                            context, 
                            'Anchor history feature coming soon!'
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _ProfileOption(
                        icon: Icons.cloud,
                        title: 'Weather Settings',
                        onTap: () {
                          NavigationHelper.showMessage(
                            context, 
                            'Weather settings coming soon!'
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _ProfileOption(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          NavigationHelper.showMessage(
                            context, 
                            'Help & support coming soon!'
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Logout Button
                ElevatedButton.icon(
                  onPressed: () async {
                    final confirmed = await NavigationHelper.confirmLogout(context);
                    if (confirmed) {
                      context.read<AuthenticationBloc>().add(
                        const AuthenticationLogoutRequested(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue.shade700,
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}