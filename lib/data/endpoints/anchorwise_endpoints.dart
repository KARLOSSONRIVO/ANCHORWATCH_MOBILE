/// AnchorWise chatbot API endpoints
class AnchorWiseEndpoints {
  // Base paths for LLM API
  static const String _llm = '/api/llm';
  
  // Chat endpoint with conversation ID parameter
  static String chat({String? conversationId}) {
    if (conversationId != null) {
      return '$_llm/chat/?conversation_id=$conversationId';
    }
    return '$_llm/chat/';
  }
}