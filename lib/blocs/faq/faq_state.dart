import 'package:equatable/equatable.dart';

/// Status enum for FAQ state
enum FaqStatus { initial, loading, success, failure }

/// State for FaqBloc
class FaqState extends Equatable {
  const FaqState({
    this.status = FaqStatus.initial,
    this.errorMessage = '',
  });

  final FaqStatus status;
  final String errorMessage;

  FaqState copyWith({
    FaqStatus? status,
    String? errorMessage,
  }) {
    return FaqState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, errorMessage];
}