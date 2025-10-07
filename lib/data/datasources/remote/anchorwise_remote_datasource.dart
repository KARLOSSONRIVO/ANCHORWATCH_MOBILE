import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../services/dio_client.dart';
import '../../endpoints/anchorwise_endpoints.dart';
import '../../models/anchorwise/chat_models.dart';

/// Remote data source for AnchorWise chatbot API
abstract class AnchorWiseRemoteDataSource {
  /// Send a chat message and get AI response
  Future<ChatResponseModel> sendChatMessage({
    required String query,
    String? conversationId,
  });
  
  /// Create a new conversation and get conversation ID
  Future<NewConversationResponseModel> createNewConversation();
}

@Injectable(as: AnchorWiseRemoteDataSource)
class AnchorWiseRemoteDataSourceImpl implements AnchorWiseRemoteDataSource {
  final DioClient _dioClient;

  AnchorWiseRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ChatResponseModel> sendChatMessage({
    required String query,
    String? conversationId,
  }) async {
    try {
      final requestModel = ChatRequestModel(query: query);
      final endpoint = AnchorWiseEndpoints.chat(conversationId: conversationId);
      
      final response = await _dioClient.post(
        endpoint,
        data: requestModel.toJson(),
        options: Options(
          receiveTimeout: const Duration(minutes: 2), // 2 minutes for AI responses
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      return ChatResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to send chat message: $e');
    }
  }

  @override
  Future<NewConversationResponseModel> createNewConversation() async {
    try {
      final response = await _dioClient.post(
        AnchorWiseEndpoints.conversations,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      return NewConversationResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create new conversation: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout. Please check your internet connection and try again.');
      case DioExceptionType.sendTimeout:
        return Exception('Request timeout. The message could not be sent. Please try again.');
      case DioExceptionType.receiveTimeout:
        return Exception('Response timeout. The AI is taking longer than expected. Please try again or check your connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      default:
        return Exception('Network error: ${error.message}');
    }
  }
}