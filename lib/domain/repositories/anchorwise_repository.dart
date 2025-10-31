import '../../data/models/anchorwise/chat_models.dart';
abstract class AnchorWiseRepository {
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
