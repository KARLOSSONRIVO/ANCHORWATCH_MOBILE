import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/discover/chart_summary/chart_summary.dart';
import '../../injection_container.dart';
import 'data_quality_indicator.dart';
import '../../data/models/chart_summary_model.dart';
import '../../data/models/data_quality_model.dart';
import '../themes/app_theme.dart';
class ChartSummaryWidget extends StatelessWidget {
  final String chartType;
  final String chartTitle;
  final String? timeFrame;
  final List<Map<String, dynamic>>? chartData;

  const ChartSummaryWidget({
    super.key,
    required this.chartType,
    required this.chartTitle,
    this.timeFrame,
    this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChartSummaryBloc>(),
      child: _ChartSummaryContent(
        chartType: chartType,
        chartTitle: chartTitle,
        timeFrame: timeFrame,
        chartData: chartData,
      ),
    );
  }
}

class _ChartSummaryContent extends StatefulWidget {
  final String chartType;
  final String chartTitle;
  final String? timeFrame;
  final List<Map<String, dynamic>>? chartData;

  const _ChartSummaryContent({
    required this.chartType,
    required this.chartTitle,
    this.timeFrame,
    this.chartData,
  });

  @override
  State<_ChartSummaryContent> createState() => _ChartSummaryContentState();
}

class _ChartSummaryContentState extends State<_ChartSummaryContent> {
  String? _lastTimeFrame;
  String? _lastChartDataHash;

  @override
  void initState() {
    super.initState();
    _lastTimeFrame = widget.timeFrame;
    _lastChartDataHash = _generateChartDataHash(widget.chartData);
  }

  @override
  void didUpdateWidget(_ChartSummaryContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentTimeFrame = widget.timeFrame;
    final currentChartDataHash = _generateChartDataHash(widget.chartData);
    
    if (_lastTimeFrame != currentTimeFrame || _lastChartDataHash != currentChartDataHash) {
      _lastTimeFrame = currentTimeFrame;
      _lastChartDataHash = currentChartDataHash;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ChartSummaryBloc>().add(const ChartSummaryClearRequested());
        }
      });
    }
  }

  String? _generateChartDataHash(List<Map<String, dynamic>>? chartData) {
    if (chartData == null || chartData.isEmpty) return null;
    final dataString = chartData.length.toString() + 
                      (chartData.isNotEmpty ? chartData.first.toString() : '');
    return dataString.hashCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartSummaryBloc, ChartSummaryState>(
      builder: (context, state) {
        final isLightMode = Theme.of(context).brightness == Brightness.light;
        final accentColor = isLightMode ? AppTheme.aiSummaryColorLight : const Color(0xFF00D4AA);
        
        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFF0F8F7) 
                : const Color(0xFF1A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        color: accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI Summary',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (state.status == ChartSummaryStatus.loading)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Generating...',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ChartSummaryBloc>().add(
                          ChartSummaryGenerateRequested(widget.chartType, widget.timeFrame, widget.chartData),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome, size: 16),
                      label: Text(state.summary == null ? 'Generate' : 'Regenerate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.summary == null 
                            ? accentColor 
                            : accentColor.withValues(alpha: 0.8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
              if (state.status == ChartSummaryStatus.loading) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFFF0F8F7) 
                        : const Color(0xFF1A2A2A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI is analyzing your chart...',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'This may take up to 2 minutes for detailed analysis',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (state.status == ChartSummaryStatus.initial && state.summary == null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFFF0F8F7).withValues(alpha: 0.5)
                        : const Color(0xFF1A2A2A).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: accentColor.withValues(alpha: 0.7),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Click Generate to get AI analysis for this chart',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (state.status == ChartSummaryStatus.loaded && state.summary != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.summary is ChartSummaryModel && 
                          (state.summary as ChartSummaryModel).dataQuality != null) ...[
                        Row(
                          children: [
                            DataQualityIndicator(
                              dataQuality: (state.summary as ChartSummaryModel).dataQuality,
                              onTap: () => _showQualityDetails(context, (state.summary as ChartSummaryModel).dataQuality!),
                            ),
                            const Spacer(),
                            if ((state.summary as ChartSummaryModel).qualityWarnings.isNotEmpty ||
                                (state.summary as ChartSummaryModel).qualityIssues.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.info_outline, size: 16),
                                onPressed: () => _showQualityDetails(context, (state.summary as ChartSummaryModel).dataQuality!),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        state.summary!.summary,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Source: ${state.summary!.source}',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 12,
                            ),
                          ),
                          if (state.summary!.cacheHit)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Cached',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (state.status == ChartSummaryStatus.error) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Failed to generate summary',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage?.contains('timeout') == true
                            ? 'The AI analysis is taking longer than expected. Please try again.'
                            : state.errorMessage ?? 'An unexpected error occurred',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                        context.read<ChartSummaryBloc>().add(
                          ChartSummaryGenerateRequested(widget.chartType, widget.timeFrame, widget.chartData),
                        );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Try Again',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showQualityDetails(BuildContext context, DataQualityModel dataQuality) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Quality Details'),
        content: SizedBox(
          width: double.maxFinite,
          child: DataQualityDetails(dataQuality: dataQuality),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

