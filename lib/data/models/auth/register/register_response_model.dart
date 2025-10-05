import '../user_model.dart';

class RegisterResponseModel {
  final String access;
  final String refresh;
  final UserModel user;

  const RegisterResponseModel({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
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
    return 'RegisterResponseModel(access: ${access.substring(0, 20)}..., refresh: ${refresh.substring(0, 20)}..., user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterResponseModel &&
        other.access == access &&
        other.refresh == refresh &&
        other.user == user;
  }

  @override
  int get hashCode => access.hashCode ^ refresh.hashCode ^ user.hashCode;
}