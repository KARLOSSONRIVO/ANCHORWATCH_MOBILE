import 'package:injectable/injectable.dart';

import '../../entities/auth_result.dart';
import '../../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResult> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}