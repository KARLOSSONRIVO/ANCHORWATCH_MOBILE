import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../services/dio_client.dart';
import '../../endpoints/anchorwise_endpoints.dart';
import '../../models/anchorwise/chat_models.dart';
abstract class AnchorWiseRemoteDataSource {
  Future<ChatResponseModel> sendChatMessage({
    required String query,
    String? conversationId,
  });
  Future<NewConversationResponseModel> createNewConversation();
  Future<ConversationsListResponseModel> getConversations();
  Future<ConversationDetailsResponseModel> getConversationById(String conversationId);
  Future<DeleteConversationResponseModel> deleteConversation(String conversationId);
  Future<bool> sendFeedback({
    required String conversationId,
    required String messageId,
    required String feedback,
  });
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
          receiveTimeout: const Duration(minutes: 8), // 8 minutes for AI responses (matches global timeout)
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

  @override
  Future<ConversationsListResponseModel> getConversations() async {
    try {
      final response = await _dioClient.get(
        AnchorWiseEndpoints.conversations,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      return ConversationsListResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch conversations: $e');
    }
  }

  @override
  Future<ConversationDetailsResponseModel> getConversationById(String conversationId) async {
    try {
      final response = await _dioClient.get(
        AnchorWiseEndpoints.conversationById(conversationId),
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      return ConversationDetailsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch conversation: $e');
    }
  }

  @override
  Future<DeleteConversationResponseModel> deleteConversation(String conversationId) async {
    try {
      final response = await _dioClient.delete(
        AnchorWiseEndpoints.deleteConversation(conversationId),
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      return DeleteConversationResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete conversation: $e');
    }
  }

  @override
  Future<bool> sendFeedback({
    required String conversationId,
    required String messageId,
    required String feedback,
  }) async {
    try {
      final response = await _dioClient.post(
        AnchorWiseEndpoints.sendFeedback,
        data: {
          'conversation_id': conversationId,
          'message_id': messageId,
          'feedback': feedback,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );
      return response.data?['success'] ?? (response.statusCode == 200);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to send feedback: $e');
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
