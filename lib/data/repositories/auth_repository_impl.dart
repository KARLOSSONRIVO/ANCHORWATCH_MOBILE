import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_result.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/password_reset/forgot_password_result.dart';
import '../../domain/entities/password_reset/verify_otp_result.dart';
import '../../domain/entities/password_reset/reset_password_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth/login/login_request_model.dart';
import '../models/auth/register/register_request_model.dart';
import '../models/auth/password_reset/password_reset_models.dart';

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

  @override
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final request = RegisterRequestModel(
      username: username,
      email: email,
      password: password,
    );

    final response = await _remoteDataSource.register(request);

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

  @override
  Future<ForgotPasswordResult> forgotPassword({
    required String email,
  }) async {
    final request = ForgotPasswordRequestModel(
      email: email,
    );

    final response = await _remoteDataSource.forgotPassword(request);

    return ForgotPasswordResult(
      message: response.message,
    );
  }

  @override
  Future<VerifyOtpResult> verifyOtp({
    required String otp,
  }) async {
    final request = VerifyOtpRequestModel(
      otp: otp,
    );

    final response = await _remoteDataSource.verifyOtp(request);

    return VerifyOtpResult(
      message: response.message,
      email: response.email,
    );
  }

  @override
  Future<ResetPasswordResult> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final request = ResetPasswordRequestModel(
      email: email,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    final response = await _remoteDataSource.resetPassword(request);

    return ResetPasswordResult(
      message: response.message,
    );
  }
}