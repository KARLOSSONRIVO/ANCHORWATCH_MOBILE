import 'package:equatable/equatable.dart';
enum ProfileStatus { loading, loaded, error, updating, navigatingToEditAccount, navigatingToContactSupport, navigatingToFAQs }
class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.loading,
    this.name = '',
    this.email = '',
    this.avatar,
    this.isDarkTheme = true,
    this.error,
  });

  final ProfileStatus status;
  final String name;
  final String email;
  final String? avatar;
  final bool isDarkTheme;
  final String? error;
  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? email,
    String? avatar,
    bool? isDarkTheme,
    String? error,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, name, email, avatar, isDarkTheme, error];

  @override
  String toString() => 'ProfileState(status: $status, name: $name, email: $email, isDarkTheme: $isDarkTheme, error: $error)';
}
