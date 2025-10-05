import '../user_model.dart';

class LoginResponseModel {
  final String access;
  final String refresh;
  final UserModel user;

  const LoginResponseModel({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return 'LoginResponseModel(access: ${access.substring(0, 20)}..., refresh: ${refresh.substring(0, 20)}..., user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginResponseModel &&
        other.access == access &&
        other.refresh == refresh &&
        other.user == user;
  }

  @override
  int get hashCode => access.hashCode ^ refresh.hashCode ^ user.hashCode;
}