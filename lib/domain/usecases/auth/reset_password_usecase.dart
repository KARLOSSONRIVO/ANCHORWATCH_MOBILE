import 'package:injectable/injectable.dart';

import '../../entities/password_reset/reset_password_result.dart';
import '../../repositories/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<ResetPasswordResult> call({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await repository.resetPassword(
      email: email, 
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}