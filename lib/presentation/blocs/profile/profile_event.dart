import 'package:equatable/equatable.dart';
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}
class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}
class ProfileUpdateRequested extends ProfileEvent {
  final String? name;
  final String? email;
  final String? avatar;

  const ProfileUpdateRequested({
    this.name,
    this.email,
    this.avatar,
  });

  @override
  List<Object> get props => [name ?? '', email ?? '', avatar ?? ''];
}
class ProfileLogoutRequested extends ProfileEvent {
  const ProfileLogoutRequested();
}
class ProfileThemeChangeRequested extends ProfileEvent {
  final bool isDarkTheme;

  const ProfileThemeChangeRequested(this.isDarkTheme);

  @override
  List<Object> get props => [isDarkTheme];
}
class ProfileNavigateToEditAccount extends ProfileEvent {
  const ProfileNavigateToEditAccount();
}
class ProfileNavigateToContactSupport extends ProfileEvent {
  const ProfileNavigateToContactSupport();
}
class ProfileNavigateToFAQs extends ProfileEvent {
  const ProfileNavigateToFAQs();
}
