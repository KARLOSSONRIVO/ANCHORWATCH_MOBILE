import 'package:injectable/injectable.dart';

import '../../domain/entities/contact/contact_support_result.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/remote/contact_remote_datasource.dart';
import '../models/contact/contact_models.dart';
import '../../services/dio_client.dart';

@LazySingleton(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource _remoteDataSource;

  const ContactRepositoryImpl({
    required ContactRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ContactSupportResult> contactSupport({required String message}) async {
    try {
    final request = ContactSupportRequestModel(message: message);

      final response = await _remoteDataSource.contactSupport(request);

      // Check if the response indicates success or failure
      if (response.success == false) {
        return ContactSupportResult.failure(
          response.message,
          retryAfterSeconds: response.retryAfterSeconds,
        );
      } else {
          return ContactSupportResult.success(response.message);
      }
    } on AppException catch (e) {
      return ContactSupportResult.failure(e.message);
    } catch (e) {
      return ContactSupportResult.failure('Contact support failed: $e');
    }
  }
}
