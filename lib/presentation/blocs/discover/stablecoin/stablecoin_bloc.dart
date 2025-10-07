import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'stablecoin_event.dart';
import 'stablecoin_state.dart';

/// BLoC for managing stablecoin state
@injectable
class StablecoinBloc extends Bloc<StablecoinEvent, StablecoinState> {
  StablecoinBloc() : super(const StablecoinState()) {
    on<StablecoinInitializeRequested>(_onStablecoinInitializeRequested);
    on<StablecoinRefreshRequested>(_onStablecoinRefreshRequested);
    on<StablecoinAggregationPeriodChanged>(_onAggregationPeriodChanged);
  }

  /// Handle initializing stablecoin data
  void _onStablecoinInitializeRequested(
    StablecoinInitializeRequested event,
    Emitter<StablecoinState> emit,
  ) async {
    emit(state.copyWith(status: StablecoinStatus.loading));

    try {
      // TODO: Replace with actual data loading logic
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data - replace with actual API call
      final mockData = _generateMockData(state.selectedPeriod);
      
      emit(state.copyWith(
        status: StablecoinStatus.loaded,
        chartData: mockData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: StablecoinStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Handle refreshing stablecoin data
  void _onStablecoinRefreshRequested(
    StablecoinRefreshRequested event,
    Emitter<StablecoinState> emit,
  ) async {
    try {
      // TODO: Replace with actual data loading logic
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data - replace with actual API call
      final mockData = _generateMockData(state.selectedPeriod);
      
      emit(state.copyWith(
        status: StablecoinStatus.loaded,
        chartData: mockData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: StablecoinStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Handle changing aggregation period
  void _onAggregationPeriodChanged(
    StablecoinAggregationPeriodChanged event,
    Emitter<StablecoinState> emit,
  ) async {
    emit(state.copyWith(
      status: StablecoinStatus.loading,
      selectedPeriod: event.period,
    ));

    try {
      // TODO: Replace with actual data loading logic
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data - replace with actual API call
      final mockData = _generateMockData(event.period);
      
      emit(state.copyWith(
        status: StablecoinStatus.loaded,
        chartData: mockData,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: StablecoinStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Generate mock data - replace with actual data models
  List<Map<String, dynamic>> _generateMockData(String period) {
    if (period == 'yearly') {
      return [
        {
          'date': '2020-01-01',
          'totalSupply': 8500000000.0,
          'mintAmount': 2000000000.0,
          'burnAmount': 500000000.0,
          'rollingAverage7': 1500000000.0,
          'rollingAverage30': 1750000000.0,
        },
        {
          'date': '2021-01-01',
          'totalSupply': 12500000000.0,
          'mintAmount': 4500000000.0,
          'burnAmount': 500000000.0,
          'rollingAverage7': 4000000000.0,
          'rollingAverage30': 3750000000.0,
        },
        {
          'date': '2022-01-01',
          'totalSupply': 18200000000.0,
          'mintAmount': 6200000000.0,
          'burnAmount': 500000000.0,
          'rollingAverage7': 5700000000.0,
          'rollingAverage30': 5450000000.0,
        },
        {
          'date': '2023-01-01',
          'totalSupply': 22800000000.0,
          'mintAmount': 5100000000.0,
          'burnAmount': 500000000.0,
          'rollingAverage7': 4600000000.0,
          'rollingAverage30': 4350000000.0,
        },
        {
          'date': '2024-01-01',
          'totalSupply': 28500000000.0,
          'mintAmount': 6200000000.0,
          'burnAmount': 500000000.0,
          'rollingAverage7': 5700000000.0,
          'rollingAverage30': 5450000000.0,
        },
      ];
    } else {
      // Monthly data
      return [
        {
          'date': '2024-01-01',
          'totalSupply': 28500000000.0,
          'mintAmount': 500000000.0,
          'burnAmount': 100000000.0,
          'rollingAverage7': 400000000.0,
          'rollingAverage30': 380000000.0,
        },
        {
          'date': '2024-02-01',
          'totalSupply': 28900000000.0,
          'mintAmount': 450000000.0,
          'burnAmount': 50000000.0,
          'rollingAverage7': 400000000.0,
          'rollingAverage30': 375000000.0,
        },
        {
          'date': '2024-03-01',
          'totalSupply': 29300000000.0,
          'mintAmount': 480000000.0,
          'burnAmount': 80000000.0,
          'rollingAverage7': 400000000.0,
          'rollingAverage30': 390000000.0,
        },
        {
          'date': '2024-04-01',
          'totalSupply': 29600000000.0,
          'mintAmount': 350000000.0,
          'burnAmount': 50000000.0,
          'rollingAverage7': 300000000.0,
          'rollingAverage30': 320000000.0,
        },
        {
          'date': '2024-05-01',
          'totalSupply': 29900000000.0,
          'mintAmount': 400000000.0,
          'burnAmount': 100000000.0,
          'rollingAverage7': 300000000.0,
          'rollingAverage30': 310000000.0,
        },
      ];
    }
  }
}