import 'package:flutter/material.dart';

/// Discover page content only (no navigation)
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Discover',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Explore maritime insights and trends',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const Expanded(
              child: Center(
                child: Text(
                  'Discover content coming soon!',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}