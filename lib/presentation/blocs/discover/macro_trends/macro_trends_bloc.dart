import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/usecases/get_macro_trends_usecase.dart';
import 'macro_trends_event.dart';
import 'macro_trends_state.dart';
@injectable
class MacroTrendsBloc extends Bloc<MacroTrendsEvent, MacroTrendsState> {
  final GetMacroTrendsUseCase _getMacroTrendsUseCase;

  MacroTrendsBloc(this._getMacroTrendsUseCase) : super(const MacroTrendsState()) {
    on<MacroTrendsLoadRequested>(_onMacroTrendsLoadRequested);
    on<MacroTrendsRefreshRequested>(_onMacroTrendsRefreshRequested);
    on<MacroTrendsAggregationPeriodChanged>(_onMacroTrendsAggregationPeriodChanged);
  }
  void _onMacroTrendsLoadRequested(
    MacroTrendsLoadRequested event,
    Emitter<MacroTrendsState> emit,
  ) async {
    emit(state.copyWith(status: MacroTrendsStatus.loading));

    try {
      final macroTrendsData = await _getMacroTrendsUseCase(
        aggregationPeriod: state.selectedPeriod,
      );
      
      emit(state.copyWith(
        status: MacroTrendsStatus.loaded,
        macroTrendsData: macroTrendsData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: MacroTrendsStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
  void _onMacroTrendsRefreshRequested(
    MacroTrendsRefreshRequested event,
    Emitter<MacroTrendsState> emit,
  ) async {
    try {
      final macroTrendsData = await _getMacroTrendsUseCase(
        aggregationPeriod: state.selectedPeriod,
      );
      
      emit(state.copyWith(
        status: MacroTrendsStatus.loaded,
        macroTrendsData: macroTrendsData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: MacroTrendsStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
  void _onMacroTrendsAggregationPeriodChanged(
    MacroTrendsAggregationPeriodChanged event,
    Emitter<MacroTrendsState> emit,
  ) async {
    emit(state.copyWith(selectedPeriod: event.period, status: MacroTrendsStatus.loading));

    try {
      final macroTrendsData = await _getMacroTrendsUseCase(
        aggregationPeriod: event.period,
      );
      
      emit(state.copyWith(
        status: MacroTrendsStatus.loaded,
        macroTrendsData: macroTrendsData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: MacroTrendsStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

}
