import 'package:injectable/injectable.dart';

import '../../endpoints/auth_endpoints.dart';
import '../../models/auth/login/login_request_model.dart';
import '../../models/auth/login/login_response_model.dart';
import '../../models/auth/register/register_request_model.dart';
import '../../models/auth/register/register_response_model.dart';
import '../../models/auth/password_reset/password_reset_models.dart';
import '../../../services/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegisterResponseModel> register(RegisterRequestModel request);
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request);
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request);
  Future<ResetPasswordResponseModel> resetPassword(ResetPasswordRequestModel request);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  const AuthRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dioClient.post(
        AuthEndpoints.login,
        data: request.toJson(),
      );

      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Login failed: $e');
    }
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dioClient.post(
        AuthEndpoints.register,
        data: request.toJson(),
      );

      return RegisterResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Registration failed: $e');
    }
  }

  @override
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request) async {
    try {
      final response = await _dioClient.post(
        AuthEndpoints.forgotPassword,
        data: request.toJson(),
      );

      return ForgotPasswordResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Forgot password failed: $e');
    }
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    try {
      final response = await _dioClient.post(
        AuthEndpoints.verifyOtp,
        data: request.toJson(),
      );

      return VerifyOtpResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('OTP verification failed: $e');
    }
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(ResetPasswordRequestModel request) async {
    try {
      final response = await _dioClient.post(
        AuthEndpoints.resetPassword,
        data: request.toJson(),
      );

      return ResetPasswordResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Password reset failed: $e');
    }
  }
}
