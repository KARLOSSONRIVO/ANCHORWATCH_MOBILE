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
  
  // New conversation endpoint
  static String get conversations => '$_llm/conversations/';
  
  // Get specific conversation by ID
  static String conversationById(String conversationId) => 
      '$_llm/conversations/?conversation_id=$conversationId';
}