import 'package:injectable/injectable.dart';

import '../../domain/entities/profile/change_password_result.dart';
import '../../domain/entities/profile/change_username_result.dart';
import '../../domain/entities/change_email/request_change_email_result.dart';
import '../../domain/entities/change_email/confirm_change_email_result.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';
import '../models/profile/profile_models.dart';
import '../models/change_email/change_email_models.dart';
import '../../services/dio_client.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ChangePasswordResult> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final request = ChangePasswordRequestModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      final response = await _remoteDataSource.changePassword(request);

      // Check if the response indicates success or failure
      if (response.success == false) {
        return ChangePasswordResult.failure(response.message);
      } else {
        return ChangePasswordResult.success(response.message);
      }
    } on AppException catch (e) {
      return ChangePasswordResult.failure(e.message);
    } catch (e) {
      return ChangePasswordResult.failure('Change password failed: $e');
    }
  }

  @override
  Future<ChangeUsernameResult> changeUsername({
    required String newUsername,
  }) async {
    try {
      final request = ChangeUsernameRequestModel(newUsername: newUsername);

      final response = await _remoteDataSource.changeUsername(request);
      return ChangeUsernameResult.success(response.message);
    } on AppException catch (e) {
      return ChangeUsernameResult.failure(e.message);
    } catch (e) {
      return ChangeUsernameResult.failure('Change username failed: $e');
    }
  }

  @override
  Future<RequestChangeEmailResult> requestChangeEmail({
    required String newEmail,
  }) async {
    try {
      final request = RequestChangeEmailRequestModel(newEmail: newEmail);

      final response = await _remoteDataSource.requestChangeEmail(request);

      // Check if the response indicates success or failure
      if (response.success == false) {
        return RequestChangeEmailResult.failure(response.message);
      } else {
        return RequestChangeEmailResult.success(response.message);
      }
    } on AppException catch (e) {
      return RequestChangeEmailResult.failure(e.message);
    } catch (e) {
      return RequestChangeEmailResult.failure(
        'Request change email failed: $e',
      );
    }
  }

  @override
  Future<ConfirmChangeEmailResult> confirmChangeEmail({
    required String otp,
    required String newEmail,
  }) async {
    try {
      final request = ConfirmChangeEmailRequestModel(
        otp: otp,
        newEmail: newEmail,
      );

      final response = await _remoteDataSource.confirmChangeEmail(request);

      // Check if the response indicates success or failure
      if (response.success == false) {
        return ConfirmChangeEmailResult.failure(response.message);
      } else {
        return ConfirmChangeEmailResult.success(response.message);
      }
    } on AppException catch (e) {
      return ConfirmChangeEmailResult.failure(e.message);
    } catch (e) {
      return ConfirmChangeEmailResult.failure(
        'Confirm change email failed: $e',
      );
    }
  }
}
