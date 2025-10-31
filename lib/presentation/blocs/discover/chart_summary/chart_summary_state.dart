import 'package:equatable/equatable.dart';
import '../../../../domain/entities/chart_summary.dart';
enum ChartSummaryStatus {
  initial,
  loading,
  loaded,
  error,
}
class ChartSummaryState extends Equatable {
  final ChartSummaryStatus status;
  final ChartSummary? summary;
  final String? errorMessage;

  const ChartSummaryState({
    this.status = ChartSummaryStatus.initial,
    this.summary,
    this.errorMessage,
  });
  ChartSummaryState copyWith({
    ChartSummaryStatus? status,
    ChartSummary? summary,
    String? errorMessage,
  }) {
    return ChartSummaryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage];
}

