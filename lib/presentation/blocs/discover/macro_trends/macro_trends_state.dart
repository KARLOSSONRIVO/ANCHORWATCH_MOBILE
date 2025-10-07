import 'package:equatable/equatable.dart';

/// Status enumeration for MacroTrends state
enum MacroTrendsStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State for the MacroTrends BLoC
class MacroTrendsState extends Equatable {
  final MacroTrendsStatus status;
  final dynamic macroTrendsData; // Replace with actual data model
  final String? errorMessage;

  const MacroTrendsState({
    this.status = MacroTrendsStatus.initial,
    this.macroTrendsData,
    this.errorMessage,
  });

  /// Create a copy of the current state with optional changes
  MacroTrendsState copyWith({
    MacroTrendsStatus? status,
    dynamic macroTrendsData,
    String? errorMessage,
  }) {
    return MacroTrendsState(
      status: status ?? this.status,
      macroTrendsData: macroTrendsData ?? this.macroTrendsData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, macroTrendsData, errorMessage];
}