import '../../data/models/anchorwise/chat_models.dart';

/// Repository interface for AnchorWise chatbot
abstract class AnchorWiseRepository {
  /// Send a chat message and get AI response
  Future<ChatResponseModel> sendChatMessage({
    required String query,
    String? conversationId,
  });
}