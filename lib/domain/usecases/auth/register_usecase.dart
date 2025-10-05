import 'package:injectable/injectable.dart';

import '../../entities/auth_result.dart';
import '../../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthResult> call({
    required String username,
    required String email,
    required String password,
  }) async {
    return await repository.register(
      username: username,
      email: email,
      password: password,
    );
  }
}