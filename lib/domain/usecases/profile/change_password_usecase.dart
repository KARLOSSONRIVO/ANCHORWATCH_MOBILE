import 'package:injectable/injectable.dart';
import '../../repositories/profile_repository.dart';
import '../../entities/profile/change_password_result.dart';

/// Use case for changing user password
@injectable
class ChangePasswordUseCase {
  final ProfileRepository _repository;

  ChangePasswordUseCase(this._repository);

  /// Execute the change password use case
  Future<ChangePasswordResult> execute({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validate inputs
    if (oldPassword.trim().isEmpty) {
      throw Exception('Current password cannot be empty');
    }
    
    if (newPassword.trim().isEmpty) {
      throw Exception('New password cannot be empty');
    }
    
    if (confirmPassword.trim().isEmpty) {
      throw Exception('Confirm password cannot be empty');
    }
    
    if (newPassword != confirmPassword) {
      throw Exception('New password and confirm password do not match');
    }
    
    if (newPassword.length < 8) {
      throw Exception('New password must be at least 8 characters long');
    }

    return await _repository.changePassword(
      oldPassword: oldPassword.trim(),
      newPassword: newPassword.trim(),
      confirmPassword: confirmPassword.trim(),
    );
  }
}