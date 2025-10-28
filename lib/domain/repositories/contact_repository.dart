import '../entities/contact/contact_support_result.dart';

abstract class ContactRepository {
  Future<ContactSupportResult> contactSupport({
    required String message,
  });
}