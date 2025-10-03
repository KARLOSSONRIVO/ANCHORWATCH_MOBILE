import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC for managing profile state
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
    on<ProfileThemeChangeRequested>(_onProfileThemeChangeRequested);
  }

  /// Load user profile data
  void _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      // Simulate API call to load profile data
      await Future.delayed(const Duration(seconds: 1));

      // Mock profile data
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        name: 'John Doe',
        email: 'john.doe@example.com',
        avatar: null,
        isDarkTheme: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        error: 'Failed to load profile: $e',
      ));
    }
  }

  /// Update user profile
  void _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      // Simulate API call to update profile
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        name: event.name,
        email: event.email,
        avatar: event.avatar,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        error: 'Failed to update profile: $e',
      ));
    }
  }

  /// Handle logout request
  void _onProfileLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) {
    // Reset profile state to initial state
    emit(const ProfileState());
  }

  /// Handle theme change request
  void _onProfileThemeChangeRequested(
    ProfileThemeChangeRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isDarkTheme: event.isDarkTheme));
  }
}