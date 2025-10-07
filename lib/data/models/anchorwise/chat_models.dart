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

/// Model for individual conversation item in conversations list
class ConversationItem {
  final String conversationId;
  final String title;
  final int messageCount;
  final String createdAt;
  final String updatedAt;
  final String? userId;
  final String lastMessage;

  ConversationItem({
    required this.conversationId,
    required this.title,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    required this.lastMessage,
  });

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    return ConversationItem(
      conversationId: json['conversation_id'] ?? '',
      title: json['title'] ?? 'Untitled Conversation',
      messageCount: json['message_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userId: json['user_id'],
      lastMessage: json['last_message'] ?? '',
    );
  }
}

/// Response model for conversations list API
class ConversationsListResponseModel {
  final bool success;
  final List<ConversationItem> conversations;
  final int totalCount;
  final String? userId;

  ConversationsListResponseModel({
    required this.success,
    required this.conversations,
    required this.totalCount,
    this.userId,
  });

  factory ConversationsListResponseModel.fromJson(Map<String, dynamic> json) {
    return ConversationsListResponseModel(
      success: json['success'] ?? false,
      conversations: (json['conversations'] as List<dynamic>?)
          ?.map((item) => ConversationItem.fromJson(item))
          .toList() ?? [],
      totalCount: json['total_count'] ?? 0,
      userId: json['user_id'],
    );
  }
}

/// Model for individual message in conversation details
class ConversationMessage {
  final String id;
  final String role;
  final String content;
  final String timestamp;
  final Map<String, dynamic> metadata;
  final dynamic feedback;

  ConversationMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    required this.metadata,
    this.feedback,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? '',
      metadata: json['metadata'] ?? {},
      feedback: json['feedback'],
    );
  }
}

/// Model for conversation details
class ConversationDetails {
  final String conversationId;
  final String title;
  final List<ConversationMessage> messages;
  final String createdAt;
  final String updatedAt;
  final String? userId;
  final Map<String, dynamic> metadata;

  ConversationDetails({
    required this.conversationId,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    required this.metadata,
  });

  factory ConversationDetails.fromJson(Map<String, dynamic> json) {
    return ConversationDetails(
      conversationId: json['conversation_id'] ?? '',
      title: json['title'] ?? 'Untitled Conversation',
      messages: (json['messages'] as List<dynamic>?)
          ?.map((item) => ConversationMessage.fromJson(item))
          .toList() ?? [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userId: json['user_id'],
      metadata: json['metadata'] ?? {},
    );
  }
}

/// Response model for specific conversation details API
class ConversationDetailsResponseModel {
  final bool success;
  final ConversationDetails conversation;
  final int messageCount;

  ConversationDetailsResponseModel({
    required this.success,
    required this.conversation,
    required this.messageCount,
  });

  factory ConversationDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ConversationDetailsResponseModel(
      success: json['success'] ?? false,
      conversation: ConversationDetails.fromJson(json['conversation'] ?? {}),
      messageCount: json['message_count'] ?? 0,
    );
  }
}

/// Response model for delete conversation API
class DeleteConversationResponseModel {
  final bool success;
  final String message;

  DeleteConversationResponseModel({
    required this.success,
    required this.message,
  });

  factory DeleteConversationResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteConversationResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Conversation deleted',
    );
  }
}