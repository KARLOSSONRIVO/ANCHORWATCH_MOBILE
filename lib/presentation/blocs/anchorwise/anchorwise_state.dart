import 'package:equatable/equatable.dart';

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
  });

  final AnchorWiseStatus status;
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;

  /// Creates a copy with new values
  AnchorWiseState copyWith({
    AnchorWiseStatus? status,
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
  }) {
    return AnchorWiseState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, messages, isTyping, error];

  @override
  String toString() => 'AnchorWiseState(status: $status, messages: ${messages.length}, isTyping: $isTyping, error: $error)';
}