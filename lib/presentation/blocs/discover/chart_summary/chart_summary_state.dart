import 'package:equatable/equatable.dart';
import '../../../../domain/entities/chart_summary.dart';

/// Status enumeration for Chart Summary state
enum ChartSummaryStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State for the Chart Summary BLoC
class ChartSummaryState extends Equatable {
  final ChartSummaryStatus status;
  final ChartSummary? summary;
  final String? errorMessage;

  const ChartSummaryState({
    this.status = ChartSummaryStatus.initial,
    this.summary,
    this.errorMessage,
  });

  /// Create a copy of the current state with optional changes
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
