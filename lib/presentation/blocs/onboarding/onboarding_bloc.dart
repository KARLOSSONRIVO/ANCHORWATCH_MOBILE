import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// BLoC for managing onboarding flow
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const String _onboardingKey = 'onboarding_completed';

  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingStatusRequested>(_onOnboardingStatusRequested);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<OnboardingReset>(_onOnboardingReset);
  }

  /// Check if user has completed onboarding
  void _onOnboardingStatusRequested(
    OnboardingStatusRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      print('🔍 Checking onboarding status...');
      
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(_onboardingKey) ?? false;
      
      print('📱 Onboarding completed: $isCompleted');
      
      emit(state.copyWith(
        status: isCompleted 
            ? OnboardingStatus.completed 
            : OnboardingStatus.notCompleted,
      ));
    } catch (e) {
      print('❌ Error checking onboarding status: $e');
      emit(state.copyWith(
        status: OnboardingStatus.notCompleted,
        error: 'Failed to check onboarding status: $e',
      ));
    }
  }

  /// Mark onboarding as completed
  void _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      print('✅ Completing onboarding...');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      
      emit(state.copyWith(status: OnboardingStatus.completed));
      
      print('🎉 Onboarding completed successfully');
    } catch (e) {
      print('❌ Error completing onboarding: $e');
      emit(state.copyWith(
        error: 'Failed to complete onboarding: $e',
      ));
    }
  }

  /// Reset onboarding status (for testing)
  void _onOnboardingReset(
    OnboardingReset event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      print('🔄 Resetting onboarding...');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingKey);
      
      emit(state.copyWith(status: OnboardingStatus.notCompleted));
      
      print('🔄 Onboarding reset successfully');
    } catch (e) {
      print('❌ Error resetting onboarding: $e');
      emit(state.copyWith(
        error: 'Failed to reset onboarding: $e',
      ));
    }
  }
}