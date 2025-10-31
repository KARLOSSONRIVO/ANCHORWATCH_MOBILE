import 'package:injectable/injectable.dart';

import '../../entities/change_email/request_change_email_result.dart';
import '../../repositories/profile_repository.dart';

@injectable
class RequestChangeEmailUseCase {
  final ProfileRepository _repository;

  RequestChangeEmailUseCase(this._repository);

  Future<RequestChangeEmailResult> execute({
    required String newEmail,
  }) async {
    if (newEmail.trim().isEmpty) {
      throw Exception('New email cannot be empty');
    }
    
    if (!_isValidEmail(newEmail)) {
      throw Exception('Please enter a valid email address');
    }

    return await _repository.requestChangeEmail(
      newEmail: newEmail.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
