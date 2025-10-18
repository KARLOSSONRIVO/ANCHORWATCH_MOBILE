import 'package:injectable/injectable.dart';
import '../../repositories/contact_repository.dart';
import '../../entities/contact/contact_support_result.dart';
@injectable
class ContactSupportUseCase {
  final ContactRepository _repository;

  ContactSupportUseCase(this._repository);
  Future<ContactSupportResult> execute({
    required String message,
  }) async {
    if (message.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }
    
    if (message.trim().length < 10) {
      throw Exception('Message must be at least 10 characters long');
    }

    return await _repository.contactSupport(message: message.trim());
  }
}
