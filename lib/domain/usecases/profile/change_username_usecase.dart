import 'package:injectable/injectable.dart';
import '../../repositories/profile_repository.dart';
import '../../entities/profile/change_username_result.dart';
@injectable
class ChangeUsernameUseCase {
  final ProfileRepository _repository;

  ChangeUsernameUseCase(this._repository);
  Future<ChangeUsernameResult> execute({
    required String newUsername,
  }) async {
    if (newUsername.trim().isEmpty) {
      throw Exception('New username cannot be empty');
    }
    
    if (newUsername.length < 3) {
      throw Exception('Username must be at least 3 characters long');
    }
    
    if (newUsername.length > 30) {
      throw Exception('Username must be less than 30 characters');
    }
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(newUsername)) {
      throw Exception('Username can only contain letters, numbers, and underscores');
    }
    
    return await _repository.changeUsername(
      newUsername: newUsername,
    );
  }
}
