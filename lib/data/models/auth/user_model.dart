import '../../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile_image_url': profileImageUrl,
    };
  }
  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      profileImageUrl: profileImageUrl,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ email.hashCode ^ profileImageUrl.hashCode;
}
