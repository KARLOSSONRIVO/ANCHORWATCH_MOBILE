import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/alerts/alerts.dart';
import '../widgets/widgets.dart';

/// Alerts page with BLoC state management
class AlertsScreenBloc extends StatelessWidget {
  const AlertsScreenBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertsBloc, AlertsState>(
      builder: (context, state) {
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
                  _showAddAlertDialog(context);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: () {
                  context.read<AlertsBloc>().add(const AlertsLoadRequested());
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          drawer: const NavigationDrawerWidget(),
          body: _buildBody(context, state),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddAlertDialog(context);
            },
            backgroundColor: Colors.blue.shade700,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AlertsState state) {
    switch (state.status) {
      case AlertsStatus.loading:
        return const Center(
          child: LoadingWidget(
            size: 48.0,
            color: Colors.blue,
            strokeWidth: 3.0,
            text: 'Loading Alerts...',
            textStyle: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
        );

      case AlertsStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                state.error ?? 'An error occurred',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
        return _buildAlertsContent(context, state);
    }
  }

  Widget _buildAlertsContent(BuildContext context, AlertsState state) {
    if (state.alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No alerts yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first alert to get notified',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _showAddAlertDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Alert'),
            ),
          ],
        ),
      );
    }

    return Padding(
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
                  state.alerts.where((a) => a.type == AlertType.price).length,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAlertCategory(
                  'Volume Alerts',
                  Icons.bar_chart,
                  Colors.blue,
                  state.alerts.where((a) => a.type == AlertType.volume).length,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAlertCategory(
                  'News Alerts',
                  Icons.newspaper,
                  Colors.orange,
                  state.alerts.where((a) => a.type == AlertType.news).length,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAlertCategory(
                  'Technical',
                  Icons.analytics,
                  Colors.purple,
                  state.alerts.where((a) => a.type == AlertType.technical).length,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Alerts list
          const Text(
            'Your Alerts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: state.alerts.length,
              itemBuilder: (context, index) {
                final alert = state.alerts[index];
                return _buildAlertCard(context, alert);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCategory(String title, IconData icon, Color color, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '$count alerts',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, AlertModel alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAlertColor(alert.type),
          child: Icon(
            _getAlertIcon(alert.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          alert.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alert.description,
              style: const TextStyle(
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(alert.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    alert.isActive ? Icons.pause : Icons.play_arrow,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(alert.isActive ? 'Disable' : 'Enable'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'toggle') {
              context.read<AlertsBloc>().add(AlertToggleRequested(alert.id));
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, alert);
            }
          },
        ),
        onTap: () {
          _showAlertDetails(context, alert);
        },
      ),
    );
  }

  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.price:
        return Colors.green;
      case AlertType.volume:
        return Colors.blue;
      case AlertType.news:
        return Colors.orange;
      case AlertType.technical:
        return Colors.purple;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.price:
        return Icons.trending_up;
      case AlertType.volume:
        return Icons.bar_chart;
      case AlertType.news:
        return Icons.newspaper;
      case AlertType.technical:
        return Icons.analytics;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  void _showAddAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddAlertDialog(),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AlertModel alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: Text('Are you sure you want to delete "${alert.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AlertsBloc>().add(AlertDeleteRequested(alert.id));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAlertDetails(BuildContext context, AlertModel alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Type: ${alert.type.name.toUpperCase()}'),
            const SizedBox(height: 8),
            Text('Description: ${alert.description}'),
            const SizedBox(height: 8),
            Text('Status: ${alert.isActive ? 'Active' : 'Disabled'}'),
            const SizedBox(height: 8),
            Text('Created: ${_formatDate(alert.createdAt)}'),
            if (alert.price != null) ...[
              const SizedBox(height: 8),
              Text('Price: \$${alert.price!.toStringAsFixed(2)}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Dialog for adding new alerts
class AddAlertDialog extends StatefulWidget {
  const AddAlertDialog({super.key});

  @override
  State<AddAlertDialog> createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends State<AddAlertDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  AlertType _selectedType = AlertType.price;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Alert'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AlertType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Alert Type',
                border: OutlineInputBorder(),
              ),
              items: AlertType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            if (_selectedType == AlertType.price) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              context.read<AlertsBloc>().add(
                AlertAddRequested(
                  type: _selectedType,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  price: _selectedType == AlertType.price
                      ? double.tryParse(_priceController.text)
                      : null,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}