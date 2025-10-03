import 'package:equatable/equatable.dart';

/// Events for the ProfileBloc
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

/// Event to load user profile data
class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

/// Event to update user profile
class ProfileUpdateRequested extends ProfileEvent {
  final String name;
  final String email;
  final String? avatar;

  const ProfileUpdateRequested({
    required this.name,
    required this.email,
    this.avatar,
  });

  @override
  List<Object> get props => [name, email, avatar ?? ''];
}

/// Event to logout user
class ProfileLogoutRequested extends ProfileEvent {
  const ProfileLogoutRequested();
}

/// Event to change theme
class ProfileThemeChangeRequested extends ProfileEvent {
  final bool isDarkTheme;

  const ProfileThemeChangeRequested(this.isDarkTheme);

  @override
  List<Object> get props => [isDarkTheme];
}