import 'package:equatable/equatable.dart';
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}
class OnboardingStatusRequested extends OnboardingEvent {
  const OnboardingStatusRequested();
}
class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}
class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
}
