import 'package:injectable/injectable.dart';

import '../../endpoints/profile_endpoints.dart';
import '../../models/profile/profile_models.dart';
import '../../models/profile/profile_picture_models.dart';
import '../../../services/dio_client.dart';

abstract class ProfileRemoteDataSource {
  Future<ChangePasswordResponseModel> changePassword(ChangePasswordRequestModel request);
  Future<ChangeUsernameResponseModel> changeUsername(ChangeUsernameRequestModel request);
  Future<GenerateProfileUploadURLResponseModel> generateProfileUploadURL(GenerateProfileUploadURLRequestModel request);
  Future<ConfirmProfileImageResponseModel> confirmProfileImage(ConfirmProfileImageRequestModel request);
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

  @override
  Future<GenerateProfileUploadURLResponseModel> generateProfileUploadURL(GenerateProfileUploadURLRequestModel request) async {
    try {
      final response = await _dioClient.post(
        ProfileEndpoints.generateProfileUploadURL,
        data: request.toJson(),
      );

      return GenerateProfileUploadURLResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      // Re-throw custom exceptions (these contain the actual API error messages)
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
      throw ServerException('Generate profile upload URL failed: $e');
    }
  }

  @override
  Future<ConfirmProfileImageResponseModel> confirmProfileImage(ConfirmProfileImageRequestModel request) async {
    try {
      final response = await _dioClient.post(
        ProfileEndpoints.confirmProfileImage,
        data: request.toJson(),
      );

      return ConfirmProfileImageResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      // Re-throw custom exceptions (these contain the actual API error messages)
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
      throw ServerException('Confirm profile image failed: $e');
    }
  }
}