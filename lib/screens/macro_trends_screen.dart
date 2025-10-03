import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Macro trends screen for economic and market analysis
class MacroTrendsScreen extends StatefulWidget {
  const MacroTrendsScreen({super.key});

  @override
  State<MacroTrendsScreen> createState() => _MacroTrendsScreenState();
}

class _MacroTrendsScreenState extends State<MacroTrendsScreen> {
  bool _isLoading = false;

  // Sample data for demonstration
  final List<MacroTrendData> _trendData = [
    MacroTrendData(
      title: 'Maritime Industry Growth',
      value: '+12.5%',
      change: '+2.3%',
      isPositive: true,
      description: 'Global maritime industry showing strong growth',
    ),
    MacroTrendData(
      title: 'Anchor Technology Investment',
      value: '\$2.1B',
      change: '+8.7%',
      isPositive: true,
      description: 'Investment in marine technology continues to rise',
    ),
    MacroTrendData(
      title: 'Safety Incidents',
      value: '234',
      change: '-15.2%',
      isPositive: true,
      description: 'Reduction in maritime safety incidents',
    ),
    MacroTrendData(
      title: 'Weather Volatility Index',
      value: '67.8',
      change: '+5.4%',
      isPositive: false,
      description: 'Increased weather unpredictability affecting maritime operations',
    ),
  ];

  final List<CorrelationData> _correlationData = [
    CorrelationData(metric1: 'Weather', metric2: 'Incidents', correlation: 0.78),
    CorrelationData(metric1: 'Technology', metric2: 'Safety', correlation: -0.65),
    CorrelationData(metric1: 'Investment', metric2: 'Growth', correlation: 0.89),
    CorrelationData(metric1: 'Volatility', metric2: 'Risk', correlation: 0.92),
  ];

  void _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      SnackBarHelper.showSuccess(context, 'Data refreshed successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF8F8F8) // Softer off-white for light mode
          : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF8F8F8) // Softer off-white for light mode
            : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: const Text(
          'Macro Trends',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
            )
          : RefreshIndicator(
              color: const Color(0xFF00D4AA),
              onRefresh: () async => _refreshData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildCard(
                      title: 'Key Performance Indicators',
                      child: _buildKPIGrid(),
                    ),
                    _buildCard(
                      title: 'Trend Analysis',
                      child: _buildTrendChart(),
                    ),
                    _buildCard(
                      title: 'Correlation Matrix',
                      child: _buildCorrelationMatrix(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCard({required String title, String? subtitle, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              if (subtitle != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildKPIGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _trendData.length,
      itemBuilder: (context, index) {
        final data = _trendData[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[50]
                : const Color(0xFF3A3A3A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                  fontFamily: 'Inter',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                data.value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    data.isPositive ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: data.isPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    data.change,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: data.isPositive ? Colors.green : Colors.red,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  data.description,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontFamily: 'Inter',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendChart() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 48,
              color: const Color(0xFF00D4AA),
            ),
            const SizedBox(height: 16),
            Text(
              'Interactive Trend Chart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Historical data visualization would appear here',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrelationMatrix() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Metrics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Correlation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        
        // Correlation rows
        ...List.generate(_correlationData.length, (index) {
          final data = _correlationData[index];
          final strength = data.correlation.abs();
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[50]
                  : const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.metric1} vs ${data.metric2}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getCorrelationStrength(strength),
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getCorrelationColor(data.correlation),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      data.correlation.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: strength > 0.6 ? Colors.white : Colors.black,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        
        // Legend
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem('Strong Negative', Colors.red),
            _buildLegendItem('Weak', Colors.grey),
            _buildLegendItem('Strong Positive', const Color(0xFF00D4AA)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
            fontSize: 9,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  String _getCorrelationStrength(double strength) {
    if (strength > 0.8) return 'Very Strong';
    if (strength > 0.6) return 'Strong';
    if (strength > 0.4) return 'Moderate';
    if (strength > 0.2) return 'Weak';
    return 'Very Weak';
  }

  Color _getCorrelationColor(double correlation) {
    final strength = correlation.abs();
    if (correlation > 0) {
      if (strength > 0.8) return const Color(0xFF00D4AA);
      if (strength > 0.6) return const Color(0xFF4DDDC7);
      if (strength > 0.4) return const Color(0xFF7DE8D3);
      return Colors.grey[300]!;
    } else {
      if (strength > 0.8) return Colors.red;
      if (strength > 0.6) return Colors.red[300]!;
      if (strength > 0.4) return Colors.red[200]!;
      return Colors.grey[300]!;
    }
  }
}

/// Data models
class MacroTrendData {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final String description;

  MacroTrendData({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.description,
  });
}

class CorrelationData {
  final String metric1;
  final String metric2;
  final double correlation;

  CorrelationData({
    required this.metric1,
    required this.metric2,
    required this.correlation,
  });
}