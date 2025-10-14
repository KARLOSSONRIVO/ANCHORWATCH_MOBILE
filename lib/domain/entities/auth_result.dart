import 'package:equatable/equatable.dart';
import 'user.dart';
import 'auth_tokens.dart';

class AuthResult extends Equatable {
  final User user;
  final AuthTokens tokens;

  const AuthResult({
    required this.user,
    required this.tokens,
  });

  @override
  List<Object?> get props => [user, tokens];

  @override
  String toString() {
    return 'AuthResult(user: $user, tokens: $tokens)';
  }

  AuthResult copyWith({
    User? user,
    AuthTokens? tokens,
  }) {
    return AuthResult(
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
    );
  }
}