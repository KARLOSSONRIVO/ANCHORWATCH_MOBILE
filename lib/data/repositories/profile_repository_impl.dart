import 'package:injectable/injectable.dart';

import '../../domain/entities/profile/change_password_result.dart';
import '../../domain/entities/profile/change_username_result.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';
import '../models/profile/profile_models.dart';
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
      return ChangePasswordResult.success(response.message);
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
      final request = ChangeUsernameRequestModel(
        newUsername: newUsername,
      );

      final response = await _remoteDataSource.changeUsername(request);
      return ChangeUsernameResult.success(response.message);
    } on AppException catch (e) {
      return ChangeUsernameResult.failure(e.message);
    } catch (e) {
      return ChangeUsernameResult.failure('Change username failed: $e');
    }
  }
}