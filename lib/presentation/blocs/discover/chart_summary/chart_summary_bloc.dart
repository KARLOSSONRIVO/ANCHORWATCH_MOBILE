import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/usecases/chart_summary/get_chart_summary_usecase.dart';
import 'chart_summary_event.dart';
import 'chart_summary_state.dart';
@injectable
class ChartSummaryBloc extends Bloc<ChartSummaryEvent, ChartSummaryState> {
  final GetChartSummaryUseCase _getChartSummaryUseCase;

  ChartSummaryBloc(this._getChartSummaryUseCase) : super(const ChartSummaryState()) {
    on<ChartSummaryGenerateRequested>(_onChartSummaryGenerateRequested);
    on<ChartSummaryClearRequested>(_onChartSummaryClearRequested);
  }
  void _onChartSummaryGenerateRequested(
    ChartSummaryGenerateRequested event,
    Emitter<ChartSummaryState> emit,
  ) async {
    emit(state.copyWith(status: ChartSummaryStatus.loading));

    try {
      final summary = await _getChartSummaryUseCase.execute(
        chartType: event.chartType,
        timeFrame: event.timeFrame,
        chartData: event.chartData,
      );
      
      emit(state.copyWith(
        status: ChartSummaryStatus.loaded,
        summary: summary,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ChartSummaryStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
  void _onChartSummaryClearRequested(
    ChartSummaryClearRequested event,
    Emitter<ChartSummaryState> emit,
  ) {
    emit(const ChartSummaryState());
  }
}

