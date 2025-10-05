import '../entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login({
    required String email,
    required String password,
  });
}