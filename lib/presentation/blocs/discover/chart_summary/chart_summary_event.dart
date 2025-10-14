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

  const ChartSummaryGenerateRequested(this.chartType, [this.timeFrame]);

  @override
  List<Object> get props => [chartType, timeFrame ?? ''];
}

/// Event to clear chart summary
class ChartSummaryClearRequested extends ChartSummaryEvent {
  const ChartSummaryClearRequested();
}
