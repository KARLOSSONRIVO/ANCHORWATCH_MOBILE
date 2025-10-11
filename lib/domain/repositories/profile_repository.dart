import '../entities/profile/change_password_result.dart';
import '../entities/profile/change_username_result.dart';
import '../entities/change_email/request_change_email_result.dart';
import '../entities/change_email/confirm_change_email_result.dart';

abstract class ProfileRepository {
  Future<ChangePasswordResult> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<ChangeUsernameResult> changeUsername({
    required String newUsername,
  });

  Future<RequestChangeEmailResult> requestChangeEmail({
    required String newEmail,
  });

  Future<ConfirmChangeEmailResult> confirmChangeEmail({
    required String otp,
    required String newEmail,
  });
}