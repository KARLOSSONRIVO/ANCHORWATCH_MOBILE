import 'package:equatable/equatable.dart';

/// Onboarding completion status
enum OnboardingStatus { 
  /// Initial state, checking onboarding status
  loading, 
  /// User needs to complete onboarding
  notCompleted, 
  /// User has completed onboarding
  completed 
}

/// Onboarding state
class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = OnboardingStatus.loading,
    this.error,
  });

  final OnboardingStatus status;
  final String? error;

  /// Creates a copy with new values
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