import '../../data/models/anchorwise/chat_models.dart';

/// Repository interface for AnchorWise chatbot
abstract class AnchorWiseRepository {
  /// Send a chat message and get AI response
  Future<ChatResponseModel> sendChatMessage({
    required String query,
    String? conversationId,
  });
  
  /// Create a new conversation and get conversation data
  Future<NewConversationResponseModel> createNewConversation();
  
  /// Get all conversations for the user
  Future<ConversationsListResponseModel> getConversations();
  
  /// Get specific conversation by ID
  Future<ConversationDetailsResponseModel> getConversationById(String conversationId);
  
  /// Delete a conversation by ID
  Future<DeleteConversationResponseModel> deleteConversation(String conversationId);
}