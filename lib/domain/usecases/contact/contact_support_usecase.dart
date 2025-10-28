import 'package:injectable/injectable.dart';
import '../../repositories/contact_repository.dart';
import '../../entities/contact/contact_support_result.dart';

@injectable
class ContactSupportUseCase {
  final ContactRepository _repository;

  ContactSupportUseCase(this._repository);
  
  Future<ContactSupportResult> execute({
    required String subject,
    required String message,
    String? userEmail,
    String? userId,
    String? username,
  }) async {
    if (subject.trim().isEmpty) {
      throw Exception('Subject cannot be empty');
    }

    if (message.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }

    if (message.trim().length < 10) {
      throw Exception('Message must be at least 10 characters long');
    }

    if (subject.trim().length > 200) {
      throw Exception('Subject must be 200 characters or less');
    }

    if (message.trim().length > 2000) {
      throw Exception('Message must be 2000 characters or less');
    }

    return await _repository.contactSupport(
      subject: subject.trim(),
      message: message.trim(),
      userEmail: userEmail,
      userId: userId,
      username: username,
    );
  }
}
