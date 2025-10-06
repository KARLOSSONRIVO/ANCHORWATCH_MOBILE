import 'package:injectable/injectable.dart';

import '../../endpoints/auth_endpoints.dart';
import '../../models/auth/login/login_request_model.dart';
import '../../models/auth/login/login_response_model.dart';
import '../../models/auth/register/register_request_model.dart';
import '../../models/auth/register/register_response_model.dart';
import '../../../services/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegisterResponseModel> register(RegisterRequestModel request);
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
      // Re-throw custom exceptions (these contain the actual API error messages)
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
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
      // Re-throw custom exceptions (these contain the actual API error messages)
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
      throw ServerException('Registration failed: $e');
    }
  }
}