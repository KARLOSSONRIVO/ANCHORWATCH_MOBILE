import 'package:injectable/injectable.dart';
import '../../domain/repositories/anchorwise_repository.dart';
import '../datasources/remote/anchorwise_remote_datasource.dart';
import '../models/anchorwise/chat_models.dart';

@Injectable(as: AnchorWiseRepository)
class AnchorWiseRepositoryImpl implements AnchorWiseRepository {
  final AnchorWiseRemoteDataSource _remoteDataSource;

  AnchorWiseRepositoryImpl(this._remoteDataSource);

  @override
  Future<ChatResponseModel> sendChatMessage({
    required String query,
    String? conversationId,
  }) async {
    try {
      return await _remoteDataSource.sendChatMessage(
        query: query,
        conversationId: conversationId,
      );
    } catch (e) {
      throw Exception('Failed to send chat message: $e');
    }
  }

  @override
  Future<NewConversationResponseModel> createNewConversation() async {
    try {
      return await _remoteDataSource.createNewConversation();
    } catch (e) {
      throw Exception('Failed to create new conversation: $e');
    }
  }

  @override
  Future<ConversationsListResponseModel> getConversations() async {
    try {
      return await _remoteDataSource.getConversations();
    } catch (e) {
      throw Exception('Failed to get conversations: $e');
    }
  }

  @override
  Future<ConversationDetailsResponseModel> getConversationById(String conversationId) async {
    try {
      return await _remoteDataSource.getConversationById(conversationId);
    } catch (e) {
      throw Exception('Failed to get conversation: $e');
    }
  }

  @override
  Future<DeleteConversationResponseModel> deleteConversation(String conversationId) async {
    try {
      return await _remoteDataSource.deleteConversation(conversationId);
    } catch (e) {
      throw Exception('Failed to delete conversation: $e');
    }
  }
}