import 'package:equatable/equatable.dart';

/// Status enumeration for Stablecoin state
enum StablecoinStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State for the Stablecoin BLoC
class StablecoinState extends Equatable {
  final StablecoinStatus status;
  final List<Map<String, dynamic>>? chartData;
  final String selectedPeriod;
  final String? errorMessage;

  const StablecoinState({
    this.status = StablecoinStatus.initial,
    this.chartData,
    this.selectedPeriod = 'monthly',
    this.errorMessage,
  });

  /// Create a copy of the current state with optional changes
  StablecoinState copyWith({
    StablecoinStatus? status,
    List<Map<String, dynamic>>? chartData,
    String? selectedPeriod,
    String? errorMessage,
  }) {
    return StablecoinState(
      status: status ?? this.status,
      chartData: chartData ?? this.chartData,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, chartData, selectedPeriod, errorMessage];
}