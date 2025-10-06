import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/alerts/alerts.dart';
import '../widgets/widgets.dart';
import '../themes/app_theme.dart';

/// Alerts page with BLoC architecture and UI design matching the mockup
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlertsBloc()..add(const AlertsLoadRequested()),
      child: const _AlertsView(),
    );
  }
}

class _AlertsView extends StatelessWidget {
  const _AlertsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertsBloc, AlertsState>(
      builder: (context, state) {
        return Container(
          color: AppTheme.getBackgroundColor(context),
          child: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AlertsState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 40),
              child: Image.asset(
                'assets/images/alert_image.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          Row(
            children: [
              Text(
                'Alert History',
                style: TextStyle(
                  color: AppTheme.getTextPrimaryColor(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/Navigation_Icons/Notifications.png',
                width: 24,
                height: 24,
                color: const Color(0xFF00D4AA),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Expanded(
            child: _buildStateContent(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, AlertsState state) {
    switch (state.status) {
      case AlertsStatus.loading:
        return const Center(
          child: LoadingWidget(),
        );
      case AlertsStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                state.error ?? 'Failed to load alerts',
                style: TextStyle(
                  color: AppTheme.getTextPrimaryColor(context),
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<AlertsBloc>().add(const AlertsLoadRequested());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case AlertsStatus.loaded:
        if (state.alerts.isEmpty) {
          return const Center(
            child: Text(
              'No alerts available',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: state.alerts.length,
          itemBuilder: (context, index) {
            final alert = state.alerts[index];
            return _buildAlertTile(context, alert, index == state.alerts.length - 1);
          },
        );
    }
  }

  Widget _buildAlertTile(BuildContext context, AlertModel alert, bool isLast) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatAlertDate(alert.createdAt),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            alert.title,
            style: TextStyle(
              color: AppTheme.getTextPrimaryColor(context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
          
          const SizedBox(height: 8),
          
          if (!isLast)
            Container(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.3),
              margin: const EdgeInsets.only(top: 8),
            ),
        ],
      ),
    );
  }

  String _formatAlertDate(DateTime dateTime) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    // Format to match the UI design (e.g., "July 21 - Global")
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    
    // For the demo, we'll use predefined locations based on alert type
    String location = 'Global';
    
    return '$month $day - $location';
  }
}
