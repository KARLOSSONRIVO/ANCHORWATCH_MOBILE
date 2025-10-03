import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Alerts page content only (no navigation)
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Alerts',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              SnackBarHelper.showInfo(context, 'Settings coming soon!');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      drawer: const NavigationDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert categories
            Row(
              children: [
                Expanded(
                  child: _buildAlertCategory(
                    'Price Alerts',
                    Icons.trending_up,
                    Colors.green,
                    3,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAlertCategory(
                    'News Alerts',
                    Icons.newspaper,
                    Colors.orange,
                    7,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAlertCategory(
                    'Risk Alerts',
                    Icons.warning,
                    Colors.red,
                    2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAlertCategory(
                    'System Alerts',
                    Icons.info,
                    Colors.blue,
                    1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Recent alerts section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Alerts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.blue.shade800,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    SnackBarHelper.showInfo(context, 'View all alerts coming soon!');
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildAlertItem(
                    'USDT Volume Alert',
                    'High trading volume detected - 150% above average',
                    '5 min ago',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  _buildAlertItem(
                    'Market News',
                    'Federal Reserve announces new monetary policy changes',
                    '23 min ago',
                    Icons.newspaper,
                    Colors.orange,
                  ),
                  _buildAlertItem(
                    'Risk Warning',
                    'USDC deviation from peg detected - Monitor closely',
                    '1 hour ago',
                    Icons.warning,
                    Colors.red,
                  ),
                  _buildAlertItem(
                    'System Update',
                    'Data synchronization completed successfully',
                    '2 hours ago',
                    Icons.check_circle,
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCategory(String title, IconData icon, Color color, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    String title,
    String description,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontFamily: 'Inter',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}