import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_result.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth/login/login_request_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(
      email: email,
      password: password,
    );

    final response = await _remoteDataSource.login(request);

    // Convert data models to domain entities
    final user = User(
      id: response.user.id,
      username: response.user.username,
      email: response.user.email,
    );

    final tokens = AuthTokens(
      accessToken: response.access,
      refreshToken: response.refresh,
    );

    return AuthResult(
      user: user,
      tokens: tokens,
    );
  }
}