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
    final tokens = json['tokens'];
    return RegisterResponseModel(
      access: _readString(json, tokens, ['access', 'access_token']),
      refresh: _readString(json, tokens, ['refresh', 'refresh_token']),
      user: UserModel.fromJson(
        _readMap(json, ['user', 'user_data']) ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'access': access, 'refresh': refresh, 'user': user.toJson()};
  }

  @override
  String toString() {
    return 'RegisterResponseModel(access: ${_truncate(access)}, refresh: ${_truncate(refresh)}, user: $user)';
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

String _readString(
  Map<String, dynamic> root,
  dynamic tokens,
  List<String> keys,
) {
  for (final key in keys) {
    final value = _extractValue(root, tokens, key);
    if (value == null) {
      continue;
    }
    if (value is String && value.isNotEmpty) {
      return value;
    }
    if (value is num || value is bool) {
      final asString = value.toString();
      if (asString.isNotEmpty) {
        return asString;
      }
    }
  }
  return '';
}

Map<String, dynamic>? _readMap(Map<String, dynamic> root, List<String> keys) {
  for (final key in keys) {
    final value = root[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
  }
  return null;
}

dynamic _extractValue(Map<String, dynamic> root, dynamic tokens, String key) {
  if (root.containsKey(key)) {
    return root[key];
  }
  if (tokens is Map<String, dynamic> && tokens.containsKey(key)) {
    return tokens[key];
  }
  return null;
}

String _truncate(String value, [int max = 20]) {
  if (value.length <= max) {
    return value;
  }
  return '${value.substring(0, max)}...';
}
