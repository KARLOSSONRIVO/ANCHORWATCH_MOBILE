import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../../services/authentication_service.dart';
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
  void _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final user = await _authService.fetchUserProfile();
      
      if (user != null) {
        await _authService.updateUserProfile(
          name: user.username,
          email: user.email,
        );
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          name: user.username,
          email: user.email,
          avatar: user.profileImageUrl,
          isDarkTheme: true, // Keep theme setting as is
          clearError: true,
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
  void _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.updating, clearError: true));

    final nextName = event.name ?? state.name;
    final nextEmail = event.email ?? state.email;
    final nextAvatar = event.avatar ?? state.avatar;

    try {
      await _authService.updateUserProfile(
        name: event.name,
        email: event.email,
      );

      final refreshedUser = await _authService.fetchUserProfile();

      if (refreshedUser != null) {
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          name: refreshedUser.username,
          email: refreshedUser.email,
          avatar: refreshedUser.profileImageUrl,
          clearError: true,
        ));
        return;
      }
    } catch (_) {
      // Swallow and fall back to optimistic update below.
    }

    emit(state.copyWith(
      status: ProfileStatus.loaded,
      name: nextName,
      email: nextEmail,
      avatar: nextAvatar,
      clearError: true,
    ));
  }
  void _onProfileLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(const ProfileState());
  }
  void _onProfileThemeChangeRequested(
    ProfileThemeChangeRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isDarkTheme: event.isDarkTheme));
  }
  void _onProfileNavigateToEditAccount(
    ProfileNavigateToEditAccount event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.navigatingToEditAccount));
  }
  void _onProfileNavigateToContactSupport(
    ProfileNavigateToContactSupport event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.navigatingToContactSupport));
  }
  void _onProfileNavigateToFAQs(
    ProfileNavigateToFAQs event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.navigatingToFAQs));
  }
}
