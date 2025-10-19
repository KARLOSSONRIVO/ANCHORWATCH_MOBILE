import 'package:injectable/injectable.dart';

import '../../endpoints/contact_endpoints.dart';
import '../../models/contact/contact_models.dart';
import '../../../services/dio_client.dart';

abstract class ContactRemoteDataSource {
  Future<ContactSupportResponseModel> contactSupport(
    ContactSupportRequestModel request,
  );
}

@LazySingleton(as: ContactRemoteDataSource)
class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final DioClient _dioClient;

  const ContactRemoteDataSourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<ContactSupportResponseModel> contactSupport(
    ContactSupportRequestModel request,
  ) async {
    try {
      final response = await _dioClient.post(
        ContactEndpoints.contactSupport,
        data: request.toJson(),
      );

      return ContactSupportResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Contact support failed: $e');
    }
  }
}
