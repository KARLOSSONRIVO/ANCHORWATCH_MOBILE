import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart';
import '../blocs/alerts/alerts.dart';
import '../widgets/widgets.dart';
import '../themes/app_theme.dart';
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AlertsBloc>()..add(const AlertsLoadRequested()),
      child: const _AlertsView(),
    );
  }
}

class _AlertsView extends StatelessWidget {
  const _AlertsView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.getBackgroundColor(context),
      child: BlocBuilder<AlertsBloc, AlertsState>(
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AlertsState state) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final accentColor = isLightMode ? AppTheme.aiSummaryColorLight : const Color(0xFF00D4AA);
    
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
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 60,
                      color: accentColor,
                    ),
                  );
                },
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
              PopupMenuButton<String>(
                icon: Icon(Icons.filter_list, color: accentColor),
                onSelected: (value) => _handleFilterSelection(context, value),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(value: 'all', child: Text('All Alerts')),
                  const PopupMenuItem(
                    value: 'critical',
                    child: Text('Critical'),
                  ),
                  const PopupMenuItem(value: 'high', child: Text('High')),
                  const PopupMenuItem(value: 'medium', child: Text('Medium')),
                  const PopupMenuItem(value: 'low', child: Text('Low')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'active',
                    child: Text('Active Only'),
                  ),
                  const PopupMenuItem(
                    value: 'resolved',
                    child: Text('Resolved Only'),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.read<AlertsBloc>().add(
                    const AlertsRefreshRequested(),
                  );
                },
                icon: Icon(Icons.refresh, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<AlertsBloc>().add(const AlertsRefreshRequested());
              },
              child: _buildStateContent(context, state),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFilterSelection(BuildContext context, String filter) {
    String? severityFilter;
    String? statusFilter;

    switch (filter) {
      case 'critical':
      case 'high':
      case 'medium':
      case 'low':
        severityFilter = filter;
        break;
      case 'active':
        statusFilter = 'active';
        break;
      case 'resolved':
        statusFilter = 'resolved';
        break;
      case 'all':
      default:
        break;
    }

    context.read<AlertsBloc>().add(
      AlertsFilterChanged(severity: severityFilter, status: statusFilter),
    );
  }

  Widget _buildStateContent(BuildContext context, AlertsState state) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final accentColor = isLightMode ? AppTheme.aiSummaryColorLight : const Color(0xFF00D4AA);
    
    if (state is AlertsLoading) {
      return const Center(child: LoadingWidget());
    }

    if (state is AlertsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading alerts',
              style: TextStyle(
                color: AppTheme.getTextPrimaryColor(context),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(
                color: AppTheme.getTextPrimaryColor(context),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<AlertsBloc>().add(const AlertsLoadRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is AlertsLoaded) {
      if (state.alerts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                size: 64,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No alerts available',
                style: TextStyle(
                  color: Colors.grey.withValues(alpha: 0.7),
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !state.hasReachedMax) {
            context.read<AlertsBloc>().add(const AlertsLoadMoreRequested());
          }
          return false;
        },
        child: ListView.builder(
          itemCount: state.alerts.length + (state.hasReachedMax ? 0 : 1),
          itemBuilder: (context, index) {
            if (index >= state.alerts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final alert = state.alerts[index];
            return _buildAlertTile(
              context,
              alert,
              index == state.alerts.length - 1,
            );
          },
        ),
      );
    }

    return const Center(child: Text('Unknown state'));
  }

  Widget _buildAlertTile(BuildContext context, alert, bool isLast) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSeverityColor(alert.severity).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAlertDetails(context, alert),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(
                        alert.severity,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      alert.severity.toUpperCase(),
                      style: TextStyle(
                        color: _getSeverityColor(alert.severity),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const Spacer(),
                  _getStatusIcon(alert.status),
                  const SizedBox(width: 8),
                  Text(
                    _formatAlertDate(alert.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                alert.title,
                style: TextStyle(
                  color: AppTheme.getTextPrimaryColor(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 4),

              Text(
                alert.message,
                style: TextStyle(
                  color: AppTheme.getTextSecondaryColor(context),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              if (alert.status == 'active') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<AlertsBloc>().add(
                          AlertAcknowledgeRequested(alert.id),
                        );
                      },
                      child: const Text('Acknowledge'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        context.read<AlertsBloc>().add(
                          AlertResolveRequested(alert.id),
                        );
                      },
                      child: const Text('Resolve'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow.shade700;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        );
      case 'acknowledged':
        return const Icon(
          Icons.check_circle_outline,
          color: Colors.orange,
          size: 16,
        );
      case 'resolved':
        return const Icon(Icons.check_circle, color: Colors.green, size: 16);
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatAlertDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago - Global';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago - Global';
    } else if (difference.inDays == 1) {
      return 'Yesterday - Global';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day} - Global';
    }
  }

  void _showAlertDetails(BuildContext context, alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.getBackgroundColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getSeverityColor(
                                alert.severity,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              alert.severity.toUpperCase(),
                              style: TextStyle(
                                color: _getSeverityColor(alert.severity),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          _getStatusIcon(alert.status),
                          const SizedBox(width: 8),
                          Text(
                            alert.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(alert.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        alert.title,
                        style: TextStyle(
                          color: AppTheme.getTextPrimaryColor(context),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatAlertDate(alert.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        alert.message,
                        style: TextStyle(
                          color: AppTheme.getTextPrimaryColor(context),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      if (alert.description != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          alert.description!,
                          style: TextStyle(
                            color: AppTheme.getTextSecondaryColor(context),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                      if (alert.data != null && alert.data!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Additional Data',
                          style: TextStyle(
                            color: AppTheme.getTextPrimaryColor(context),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.getCardBackgroundColor(context),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            alert.data.toString(),
                            style: TextStyle(
                              color: AppTheme.getTextSecondaryColor(context),
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                      if (alert.status == 'active') ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<AlertsBloc>().add(
                                    AlertAcknowledgeRequested(alert.id),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text('Acknowledge'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<AlertsBloc>().add(
                                    AlertResolveRequested(alert.id),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text('Resolve'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.red;
      case 'acknowledged':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

