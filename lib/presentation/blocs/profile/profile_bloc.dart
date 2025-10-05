import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../../services/authentication_service.dart';

/// BLoC for managing profile state
@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthenticationService _authService;
  
  ProfileBloc(this._authService) : super(const ProfileState()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
    on<ProfileThemeChangeRequested>(_onProfileThemeChangeRequested);
    on<ProfileNavigateToEditAccount>(_onProfileNavigateToEditAccount);
    on<ProfileNavigateToContactSupport>(_onProfileNavigateToContactSupport);
    on<ProfileNavigateToFAQs>(_onProfileNavigateToFAQs);
  }

  /// Load user profile data
  void _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      // Fetch user profile from server
      final user = await _authService.fetchUserProfile();
      
      if (user != null) {
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          name: user.username,
          email: user.email,
          avatar: user.profileImageUrl,
          isDarkTheme: true, // Keep theme setting as is
        ));
      } else {
        emit(state.copyWith(
          status: ProfileStatus.error,
          error: 'Failed to load profile data',
        ));
      }
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

  /// Handle navigation to edit account
  void _onProfileNavigateToEditAccount(
    ProfileNavigateToEditAccount event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.navigatingToEditAccount));
  }

  /// Handle navigation to contact support
  void _onProfileNavigateToContactSupport(
    ProfileNavigateToContactSupport event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.navigatingToContactSupport));
  }

  /// Handle navigation to FAQs
  void _onProfileNavigateToFAQs(
    ProfileNavigateToFAQs event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.navigatingToFAQs));
  }
}