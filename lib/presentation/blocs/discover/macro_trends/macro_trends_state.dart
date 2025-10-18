import 'package:equatable/equatable.dart';
import '../../../../domain/entities/macro_trends.dart';
enum MacroTrendsStatus {
  initial,
  loading,
  loaded,
  error,
}
class MacroTrendsState extends Equatable {
  final MacroTrendsStatus status;
  final MacroTrendsData? macroTrendsData;
  final String? errorMessage;
  final String selectedPeriod;

  const MacroTrendsState({
    this.status = MacroTrendsStatus.initial,
    this.macroTrendsData,
    this.errorMessage,
    this.selectedPeriod = 'yearly',
  });
  MacroTrendsState copyWith({
    MacroTrendsStatus? status,
    MacroTrendsData? macroTrendsData,
    String? errorMessage,
    String? selectedPeriod,
  }) {
    return MacroTrendsState(
      status: status ?? this.status,
      macroTrendsData: macroTrendsData ?? this.macroTrendsData,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }

  @override
  List<Object?> get props => [status, macroTrendsData, errorMessage, selectedPeriod];
}
