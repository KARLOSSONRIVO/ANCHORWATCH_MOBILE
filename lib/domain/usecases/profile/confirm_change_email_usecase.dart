import 'package:injectable/injectable.dart';

import '../../entities/change_email/confirm_change_email_result.dart';
import '../../repositories/profile_repository.dart';

@injectable
class ConfirmChangeEmailUseCase {
  final ProfileRepository _repository;

  ConfirmChangeEmailUseCase(this._repository);

  Future<ConfirmChangeEmailResult> execute({
    required String otp,
    required String newEmail,
  }) async {
    // Validate inputs
    if (otp.trim().isEmpty) {
      throw Exception('OTP cannot be empty');
    }
    
    if (newEmail.trim().isEmpty) {
      throw Exception('Email cannot be empty');
    }
    
    if (otp.length != 6) {
      throw Exception('OTP must be 6 digits');
    }

    return await _repository.confirmChangeEmail(
      otp: otp.trim(),
      newEmail: newEmail.trim(),
    );
  }
}