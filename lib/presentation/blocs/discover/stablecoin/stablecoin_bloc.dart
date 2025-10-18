import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/usecases/stablecoin/get_stablecoin_chart_data_usecase.dart';
import '../../../../domain/entities/stablecoin_chart_data.dart';
import 'stablecoin_event.dart';
import 'stablecoin_state.dart';
@injectable
class StablecoinBloc extends Bloc<StablecoinEvent, StablecoinState> {
  final GetStablecoinChartDataUseCase _getStablecoinChartDataUseCase;

  StablecoinBloc(this._getStablecoinChartDataUseCase) : super(const StablecoinState()) {
    on<StablecoinInitializeRequested>(_onStablecoinInitializeRequested);
    on<StablecoinRefreshRequested>(_onStablecoinRefreshRequested);
    on<StablecoinAggregationPeriodChanged>(_onAggregationPeriodChanged);
  }
  void _onStablecoinInitializeRequested(
    StablecoinInitializeRequested event,
    Emitter<StablecoinState> emit,
  ) async {
    emit(state.copyWith(status: StablecoinStatus.loading));

    try {
      final chartData = await _getStablecoinChartDataUseCase.execute(
        aggregationPeriod: state.selectedPeriod,
      );
      final chartDisplayData = _convertToDisplayData(chartData);
      
      emit(state.copyWith(
        status: StablecoinStatus.loaded,
        chartData: chartDisplayData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: StablecoinStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
  void _onStablecoinRefreshRequested(
    StablecoinRefreshRequested event,
    Emitter<StablecoinState> emit,
  ) async {
    try {
      final chartData = await _getStablecoinChartDataUseCase.execute(
        aggregationPeriod: state.selectedPeriod,
      );
      final chartDisplayData = _convertToDisplayData(chartData);
      
      emit(state.copyWith(
        status: StablecoinStatus.loaded,
        chartData: chartDisplayData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: StablecoinStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
  void _onAggregationPeriodChanged(
    StablecoinAggregationPeriodChanged event,
    Emitter<StablecoinState> emit,
  ) async {
    emit(state.copyWith(
      status: StablecoinStatus.loading,
      selectedPeriod: event.period,
    ));

    try {
      final chartData = await _getStablecoinChartDataUseCase.execute(
        aggregationPeriod: event.period,
      );
      final chartDisplayData = _convertToDisplayData(chartData);
      
      emit(state.copyWith(
        status: StablecoinStatus.loaded,
        chartData: chartDisplayData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: StablecoinStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
  List<Map<String, dynamic>> _convertToDisplayData(StablecoinChartData chartData) {
    final allDates = <DateTime>{};
    allDates.addAll(chartData.totalSupplyOverTime.map((d) => d.date));
    allDates.addAll(chartData.mintBurnActivity.map((d) => d.date));
    allDates.addAll(chartData.netChangeInSupply.map((d) => d.date));
    allDates.addAll(chartData.rollingAverageSupplyChanges.map((d) => d.date));
    
    final sortedDates = allDates.toList()..sort();
    
    return sortedDates.map((date) {
      final supplyData = chartData.totalSupplyOverTime
          .where((d) => d.date.isAtSameMomentAs(date))
          .firstOrNull;
      
      final mintBurnData = chartData.mintBurnActivity
          .where((d) => d.date.isAtSameMomentAs(date))
          .firstOrNull;
      
      final rollingAvgData = chartData.rollingAverageSupplyChanges
          .where((d) => d.date.isAtSameMomentAs(date))
          .firstOrNull;
      
      return {
        'date': date.toIso8601String(),
        'totalSupply': supplyData?.supplyClosing ?? 0.0,
        'mintAmount': mintBurnData?.mintUsd ?? 0.0,
        'burnAmount': mintBurnData?.burnUsd ?? 0.0,
        'rollingAverage7': rollingAvgData?.shortTermAvg ?? 0.0,
        'rollingAverage30': rollingAvgData?.longTermAvg ?? 0.0,
      };
    }).toList();
  }
}
