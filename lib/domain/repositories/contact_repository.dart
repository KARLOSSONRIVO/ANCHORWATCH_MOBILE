import '../entities/contact/contact_support_result.dart';

abstract class ContactRepository {
  Future<ContactSupportResult> contactSupport({
    required String subject,
    required String message,
    String? userEmail,
    String? userId,
    String? username,
  });
}