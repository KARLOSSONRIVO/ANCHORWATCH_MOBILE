import 'package:equatable/equatable.dart';

/// Base class for onboarding events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

/// Event to check if user has completed onboarding
class OnboardingStatusRequested extends OnboardingEvent {
  const OnboardingStatusRequested();
}

/// Event to complete onboarding process
class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

/// Event to reset onboarding (for testing purposes)
class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
}