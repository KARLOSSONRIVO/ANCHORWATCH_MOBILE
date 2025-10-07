/// Request model for chat API
class ChatRequestModel {
  final String query;

  ChatRequestModel({
    required this.query,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
    };
  }
}

/// Response model for chat API
class ChatResponseModel {
  final String response;
  final String timestamp;

  ChatResponseModel({
    required this.response,
    required this.timestamp,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      response: json['response'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}

/// Response model for new conversation API
class NewConversationResponseModel {
  final bool success;
  final String message;
  final String conversationId;

  NewConversationResponseModel({
    required this.success,
    required this.message,
    required this.conversationId,
  });

  factory NewConversationResponseModel.fromJson(Map<String, dynamic> json) {
    return NewConversationResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      conversationId: json['conversation_id'] ?? '',
    );
  }
}