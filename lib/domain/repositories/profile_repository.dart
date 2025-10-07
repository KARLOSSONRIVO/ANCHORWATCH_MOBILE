import '../entities/profile/change_password_result.dart';
import '../entities/profile/change_username_result.dart';

abstract class ProfileRepository {
  Future<ChangePasswordResult> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<ChangeUsernameResult> changeUsername({
    required String newUsername,
  });
}