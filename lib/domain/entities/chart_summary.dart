import 'package:equatable/equatable.dart';
class ChartSummary extends Equatable {
  final String chartType;
  final String summary;
  final String source;
  final bool cacheHit;
  final DateTime timestamp;

  const ChartSummary({
    required this.chartType,
    required this.summary,
    required this.source,
    required this.cacheHit,
    required this.timestamp,
  });

  @override
  List<Object> get props => [chartType, summary, source, cacheHit, timestamp];
}

