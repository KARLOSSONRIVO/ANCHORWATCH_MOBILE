import 'package:equatable/equatable.dart';
enum OnboardingStatus { 
  loading, 
  notCompleted, 
  completed 
}
class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = OnboardingStatus.loading,
    this.error,
  });

  final OnboardingStatus status;
  final String? error;
  OnboardingState copyWith({
    OnboardingStatus? status,
    String? error,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, error];

  @override
  String toString() => 'OnboardingState(status: $status, error: $error)';
}
