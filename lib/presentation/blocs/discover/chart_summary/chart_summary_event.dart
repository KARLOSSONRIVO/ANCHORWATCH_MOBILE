import 'package:equatable/equatable.dart';

/// Events for the Chart Summary BLoC
abstract class ChartSummaryEvent extends Equatable {
  const ChartSummaryEvent();

  @override
  List<Object> get props => [];
}

/// Event to generate chart summary for a specific chart type
class ChartSummaryGenerateRequested extends ChartSummaryEvent {
  final String chartType;
  final String? timeFrame;
  final List<Map<String, dynamic>>? chartData;

  const ChartSummaryGenerateRequested(this.chartType, [this.timeFrame, this.chartData]);

  @override
  List<Object> get props => [chartType, timeFrame ?? '', chartData ?? []];
}

/// Event to clear chart summary
class ChartSummaryClearRequested extends ChartSummaryEvent {
  const ChartSummaryClearRequested();
}
