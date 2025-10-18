import 'package:equatable/equatable.dart';
enum StablecoinStatus {
  initial,
  loading,
  loaded,
  error,
}
class StablecoinState extends Equatable {
  final StablecoinStatus status;
  final List<Map<String, dynamic>>? chartData;
  final String selectedPeriod;
  final String? errorMessage;

  const StablecoinState({
    this.status = StablecoinStatus.initial,
    this.chartData,
    this.selectedPeriod = 'yearly',
    this.errorMessage,
  });
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
