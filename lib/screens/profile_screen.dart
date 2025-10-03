import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Profile page content with dark theme (no navigation)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              SnackBarHelper.showInfo(context, 'Settings coming soon!');
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      drawer: const NavigationDrawerWidget(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Profile Screen Content',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}