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
  Future<ContactSupportResult> contactSupport({
    required String message,
  }) async {
    try {
      final request = ContactSupportRequestModel(
        message: message,
      );

      final response = await _remoteDataSource.contactSupport(request);
      return ContactSupportResult(message: response.message);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Contact support failed: $e');
    }
  }
}