import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, username, email, profileImageUrl];

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, profileImageUrl: $profileImageUrl)';
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}