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

      final data = _extractResponseData(response.data);
      return LoginResponseModel.fromJson(data);
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

      final data = _extractResponseData(response.data);
      return RegisterResponseModel.fromJson(data);
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

      final data = _extractResponseData(response.data);
      return ForgotPasswordResponseModel.fromJson(data);
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

      final data = _extractResponseData(response.data);
      return VerifyOtpResponseModel.fromJson(data);
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

      final data = _extractResponseData(response.data);
      return ResetPasswordResponseModel.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Password reset failed: $e');
    }
  }

  Map<String, dynamic> _extractResponseData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final payload = responseData['data'];
      if (payload is Map<String, dynamic>) {
        return Map<String, dynamic>.from(payload);
      }

      if (payload == null && responseData.containsKey('data')) {
        return <String, dynamic>{};
      }

      return Map<String, dynamic>.from(responseData);
    }

    throw const ServerException('Unexpected response format from server.');
  }
}
