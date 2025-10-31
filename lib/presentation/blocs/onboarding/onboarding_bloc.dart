import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';
@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const String _onboardingKey = 'onboarding_completed';

  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingStatusRequested>(_onOnboardingStatusRequested);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<OnboardingReset>(_onOnboardingReset);
  }
  void _onOnboardingStatusRequested(
    OnboardingStatusRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(_onboardingKey) ?? false;
      
      emit(state.copyWith(
        status: isCompleted 
            ? OnboardingStatus.completed 
            : OnboardingStatus.notCompleted,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OnboardingStatus.notCompleted,
        error: 'Failed to check onboarding status: $e',
      ));
    }
  }
  void _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      
      emit(state.copyWith(status: OnboardingStatus.completed));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to complete onboarding: $e',
      ));
    }
  }
  void _onOnboardingReset(
    OnboardingReset event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingKey);
      
      emit(state.copyWith(status: OnboardingStatus.notCompleted));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to reset onboarding: $e',
      ));
    }
  }
}

