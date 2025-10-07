import 'package:injectable/injectable.dart';

import '../../endpoints/profile_endpoints.dart';
import '../../models/profile/profile_models.dart';
import '../../../services/dio_client.dart';

abstract class ProfileRemoteDataSource {
  Future<ChangePasswordResponseModel> changePassword(ChangePasswordRequestModel request);
  Future<ChangeUsernameResponseModel> changeUsername(ChangeUsernameRequestModel request);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  const ProfileRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<ChangePasswordResponseModel> changePassword(ChangePasswordRequestModel request) async {
    try {
      final response = await _dioClient.post(
        ProfileEndpoints.changePassword,
        data: request.toJson(),
      );

      return ChangePasswordResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      // Re-throw custom exceptions (these contain the actual API error messages)
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
      throw ServerException('Change password failed: $e');
    }
  }

  @override
  Future<ChangeUsernameResponseModel> changeUsername(ChangeUsernameRequestModel request) async {
    try {
      final response = await _dioClient.post(
        ProfileEndpoints.changeUsername,
        data: request.toJson(),
      );

      return ChangeUsernameResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      // Re-throw custom exceptions (these contain the actual API error messages)
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
      throw ServerException('Change username failed: $e');
    }
  }
}