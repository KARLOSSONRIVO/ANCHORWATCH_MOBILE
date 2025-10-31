import 'package:equatable/equatable.dart';
abstract class ChartSummaryEvent extends Equatable {
  const ChartSummaryEvent();

  @override
  List<Object> get props => [];
}
class ChartSummaryGenerateRequested extends ChartSummaryEvent {
  final String chartType;
  final String? timeFrame;
  final List<Map<String, dynamic>>? chartData;

  const ChartSummaryGenerateRequested(this.chartType, [this.timeFrame, this.chartData]);

  @override
  List<Object> get props => [chartType, timeFrame ?? '', chartData ?? []];
}
class ChartSummaryClearRequested extends ChartSummaryEvent {
  const ChartSummaryClearRequested();
}

