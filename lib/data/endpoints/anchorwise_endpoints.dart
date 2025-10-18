class AnchorWiseEndpoints {
  static const String _llm = '/api/llm';
  static String chat({String? conversationId}) {
    if (conversationId != null) {
      return '$_llm/chat/?conversation_id=$conversationId';
    }
    return '$_llm/chat/';
  }
  static String get conversations => '$_llm/conversations/';
  static String conversationById(String conversationId) => 
      '$_llm/conversations/?conversation_id=$conversationId';
  static String deleteConversation(String conversationId) => 
      '$_llm/conversations/?conversation_id=$conversationId';
  static String get sendFeedback => '$_llm/feedback/';
}
