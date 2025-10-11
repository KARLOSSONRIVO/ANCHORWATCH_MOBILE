import 'package:injectable/injectable.dart';

import '../../endpoints/contact_endpoints.dart';
import '../../models/contact/contact_models.dart';
import '../../../services/dio_client.dart';

abstract class ContactRemoteDataSource {
  Future<ContactSupportResponseModel> contactSupport(ContactSupportRequestModel request);
}

@LazySingleton(as: ContactRemoteDataSource)
class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final DioClient _dioClient;

  const ContactRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<ContactSupportResponseModel> contactSupport(ContactSupportRequestModel request) async {
    try {
      print('[CONTACT_SUPPORT] Making request to: ${ContactEndpoints.contactSupport}');
      print('[CONTACT_SUPPORT] Request data: ${request.toJson()}');
      
      final response = await _dioClient.post(
        ContactEndpoints.contactSupport,
        data: request.toJson(),
      );

      print('[CONTACT_SUPPORT] Response received: ${response.data}');
      return ContactSupportResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on AppException catch (e) {
      print('[CONTACT_SUPPORT] AppException: ${e.message}');
      // Re-throw custom exceptions (these contain the actual API error messages)
      rethrow;
    } catch (e) {
      print('[CONTACT_SUPPORT] Unexpected error: $e');
      // Handle any other unexpected errors
      throw ServerException('Contact support failed: $e');
    }
  }
}