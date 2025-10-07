import 'package:equatable/equatable.dart';
import '../../../data/models/anchorwise/chat_models.dart';

/// Message sender type
enum MessageSender { user, ai }

/// Chat message model
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;

  @override
  List<Object> get props => [id, content, sender, timestamp];
}

/// AnchorWise status enum
enum AnchorWiseStatus { idle, sending, loading, error }

/// AnchorWise state
class AnchorWiseState extends Equatable {
  const AnchorWiseState({
    this.status = AnchorWiseStatus.idle,
    this.messages = const [],
    this.isTyping = false,
    this.error,
    this.currentConversationId,
    this.conversations = const [],
    this.isLoadingConversations = false,
  });

  final AnchorWiseStatus status;
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;
  final String? currentConversationId;
  final List<ConversationItem> conversations;
  final bool isLoadingConversations;

  /// Creates a copy with new values
  AnchorWiseState copyWith({
    AnchorWiseStatus? status,
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
    String? currentConversationId,
    List<ConversationItem>? conversations,
    bool? isLoadingConversations,
  }) {
    return AnchorWiseState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error ?? this.error,
      currentConversationId: currentConversationId ?? this.currentConversationId,
      conversations: conversations ?? this.conversations,
      isLoadingConversations: isLoadingConversations ?? this.isLoadingConversations,
    );
  }

  @override
  List<Object?> get props => [status, messages, isTyping, error, currentConversationId, conversations, isLoadingConversations];

  @override
  String toString() => 'AnchorWiseState(status: $status, messages: ${messages.length}, isTyping: $isTyping, error: $error, conversationId: $currentConversationId, conversations: ${conversations.length})';
}