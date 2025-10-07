import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'macro_trends_event.dart';
import 'macro_trends_state.dart';

/// BLoC for managing macro trends state
@injectable
class MacroTrendsBloc extends Bloc<MacroTrendsEvent, MacroTrendsState> {
  MacroTrendsBloc() : super(const MacroTrendsState()) {
    on<MacroTrendsLoadRequested>(_onMacroTrendsLoadRequested);
    on<MacroTrendsRefreshRequested>(_onMacroTrendsRefreshRequested);
  }

  /// Handle loading macro trends data
  void _onMacroTrendsLoadRequested(
    MacroTrendsLoadRequested event,
    Emitter<MacroTrendsState> emit,
  ) async {
    emit(state.copyWith(status: MacroTrendsStatus.loading));

    try {
      // TODO: Replace with actual data loading logic
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data - replace with actual API call
      final mockData = _generateMockData();
      
      emit(state.copyWith(
        status: MacroTrendsStatus.loaded,
        macroTrendsData: mockData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: MacroTrendsStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Handle refreshing macro trends data
  void _onMacroTrendsRefreshRequested(
    MacroTrendsRefreshRequested event,
    Emitter<MacroTrendsState> emit,
  ) async {
    // Don't show loading state for refresh
    try {
      // TODO: Replace with actual data loading logic
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data - replace with actual API call
      final mockData = _generateMockData();
      
      emit(state.copyWith(
        status: MacroTrendsStatus.loaded,
        macroTrendsData: mockData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: MacroTrendsStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Generate mock data - replace with actual data models
  dynamic _generateMockData() {
    return {
      'inflationTimeline': [
        {'year': 2020, 'inflationRate': 1.4},
        {'year': 2021, 'inflationRate': 4.7},
        {'year': 2022, 'inflationRate': 8.0},
        {'year': 2023, 'inflationRate': 4.1},
        {'year': 2024, 'inflationRate': 2.5},
      ],
      'inflationVsSupplyGrowth': [
        {'year': 2020, 'inflationRate': 1.4, 'supplyGrowthPct': 12.5},
        {'year': 2021, 'inflationRate': 4.7, 'supplyGrowthPct': 8.2},
        {'year': 2022, 'inflationRate': 8.0, 'supplyGrowthPct': 3.1},
        {'year': 2023, 'inflationRate': 4.1, 'supplyGrowthPct': 5.7},
        {'year': 2024, 'inflationRate': 2.5, 'supplyGrowthPct': 7.3},
      ],
      'correlationTable': [
        {
          'inflationRate': 1.0,
          'price': 0.65,
          'marketCap': 0.72,
          'supplyClosing': -0.43,
          'netChangeUsd': 0.58,
        },
        {
          'inflationRate': 0.65,
          'price': 1.0,
          'marketCap': 0.89,
          'supplyClosing': -0.21,
          'netChangeUsd': 0.76,
        },
        {
          'inflationRate': 0.72,
          'price': 0.89,
          'marketCap': 1.0,
          'supplyClosing': -0.15,
          'netChangeUsd': 0.83,
        },
        {
          'inflationRate': -0.43,
          'price': -0.21,
          'marketCap': -0.15,
          'supplyClosing': 1.0,
          'netChangeUsd': -0.38,
        },
        {
          'inflationRate': 0.58,
          'price': 0.76,
          'marketCap': 0.83,
          'supplyClosing': -0.38,
          'netChangeUsd': 1.0,
        },
      ],
    };
  }
}