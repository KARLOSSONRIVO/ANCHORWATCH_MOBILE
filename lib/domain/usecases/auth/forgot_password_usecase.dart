import 'package:injectable/injectable.dart';

import '../../entities/password_reset/forgot_password_result.dart';
import '../../repositories/auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<ForgotPasswordResult> call({
    required String email,
  }) async {
    return await repository.forgotPassword(email: email);
  }
}