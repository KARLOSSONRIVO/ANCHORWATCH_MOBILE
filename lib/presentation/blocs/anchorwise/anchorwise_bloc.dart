import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/anchorwise/send_chat_message_usecase.dart';
import '../../../domain/usecases/anchorwise/create_new_conversation_usecase.dart';
import '../../../domain/usecases/anchorwise/get_conversations_usecase.dart';
import '../../../domain/usecases/anchorwise/get_conversation_by_id_usecase.dart';
import '../../../domain/usecases/anchorwise/delete_conversation_usecase.dart';
import '../../../domain/usecases/anchorwise/send_feedback_usecase.dart';
import 'anchorwise_event.dart';
import 'anchorwise_state.dart';

/// BLoC for managing AnchorWise chat functionality
@injectable
class AnchorWiseBloc extends Bloc<AnchorWiseEvent, AnchorWiseState> {
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final CreateNewConversationUseCase _createNewConversationUseCase;
  final GetConversationsUseCase _getConversationsUseCase;
  final GetConversationByIdUseCase _getConversationByIdUseCase;
  final DeleteConversationUseCase _deleteConversationUseCase;
  final SendFeedbackUseCase _sendFeedbackUseCase;
  String? _currentConversationId;

  AnchorWiseBloc(
    this._sendChatMessageUseCase, 
    this._createNewConversationUseCase,
    this._getConversationsUseCase,
    this._getConversationByIdUseCase,
    this._deleteConversationUseCase,
    this._sendFeedbackUseCase,
  ) : super(const AnchorWiseState()) {
    on<AnchorWiseSendMessage>(_onSendMessage);
    on<AnchorWiseLoadHistory>(_onLoadHistory);
    on<AnchorWiseClearConversation>(_onClearConversation);
    on<AnchorWiseToggleTyping>(_onToggleTyping);
    on<AnchorWiseCancelRequest>(_onCancelRequest);
    on<AnchorWiseCreateNewConversation>(_onCreateNewConversation);
    on<AnchorWiseLoadConversations>(_onLoadConversations);
    on<AnchorWiseSelectConversation>(_onSelectConversation);
    on<AnchorWiseDeleteConversation>(_onDeleteConversation);
    on<AnchorWiseSendPositiveFeedback>(_onSendPositiveFeedback);
    on<AnchorWiseSendNegativeFeedback>(_onSendNegativeFeedback);
  }

  /// Send message and get AI response
  void _onSendMessage(
    AnchorWiseSendMessage event,
    Emitter<AnchorWiseState> emit,
  ) async {
    if (event.message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      conversationId: _currentConversationId ?? state.currentConversationId,
    );

    final updatedMessages = [...state.messages, userMessage];
    emit(state.copyWith(
      messages: updatedMessages,
      status: AnchorWiseStatus.sending,
    ));

    // Show typing indicator
    emit(state.copyWith(isTyping: true));

    try {
      // Call real API
      final response = await _sendChatMessageUseCase.execute(
        query: event.message,
        conversationId: _currentConversationId,
      );

      // Update conversation ID if it's returned from the response (for new conversations)
      if (response.conversationId != null && response.conversationId!.isNotEmpty) {
        _currentConversationId = response.conversationId!;
        print('🔍 BLoC: Updated conversation ID from response: $_currentConversationId');
      }

      // Instead of creating our own messages, let's reload the conversation to get the proper IDs
      if (_currentConversationId != null) {
        print('🔍 BLoC: Reloading conversation to get proper message IDs');
        try {
          final conversationResponse = await _getConversationByIdUseCase.execute(_currentConversationId!);
          
          // Convert API messages to ChatMessage format with proper backend IDs
          final chatMessages = conversationResponse.conversation.messages.map((msg) {
            return ChatMessage(
              id: msg.id, // Use the actual backend message ID
              content: msg.content,
              sender: msg.role == 'user' ? MessageSender.user : MessageSender.ai,
              timestamp: DateTime.parse(msg.timestamp),
              conversationId: conversationResponse.conversation.conversationId,
            );
          }).toList();
          
          print('🔍 BLoC: Loaded ${chatMessages.length} messages with backend IDs');
          for (final msg in chatMessages) {
            print('🔍 Message: ${msg.id} (${msg.sender}) - ${msg.content.substring(0, msg.content.length > 30 ? 30 : msg.content.length)}...');
          }
          
          emit(state.copyWith(
            status: AnchorWiseStatus.idle,
            messages: chatMessages,
            isTyping: false,
            currentConversationId: _currentConversationId,
          ));
          return;
        } catch (e) {
          print('❌ BLoC: Failed to reload conversation: $e');
          // Fall back to the original approach
        }
      }

      // Fallback: Parse timestamp from API response
      DateTime responseTimestamp;
      try {
        responseTimestamp = DateTime.parse(response.timestamp);
      } catch (e) {
        responseTimestamp = DateTime.now();
      }
      
      // Use message ID from API response if available, otherwise generate one
      final aiMessageId = response.messageId ?? (DateTime.now().millisecondsSinceEpoch + 1).toString();
      print('🔍 BLoC: AI message ID from API: $aiMessageId');
      
      final aiMessage = ChatMessage(
        id: aiMessageId,
        content: response.response,
        sender: MessageSender.ai,
        timestamp: responseTimestamp,
        conversationId: _currentConversationId,
      );

      // Update the user message with the conversation ID if it was null
      List<ChatMessage> finalMessages;
      if (userMessage.conversationId == null && _currentConversationId != null) {
        final updatedUserMessage = ChatMessage(
          id: userMessage.id,
          content: userMessage.content,
          sender: userMessage.sender,
          timestamp: userMessage.timestamp,
          conversationId: _currentConversationId,
        );
        finalMessages = [
          ...updatedMessages.where((msg) => msg.id != userMessage.id),
          updatedUserMessage,
          aiMessage
        ];
      } else {
        finalMessages = [...updatedMessages, aiMessage];
      }
      
      emit(state.copyWith(
        status: AnchorWiseStatus.idle,
        messages: finalMessages,
        isTyping: false,
        currentConversationId: _currentConversationId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnchorWiseStatus.error,
        error: 'Failed to send message: $e',
        isTyping: false,
      ));
    }
  }

  /// Load conversation history
  void _onLoadHistory(
    AnchorWiseLoadHistory event,
    Emitter<AnchorWiseState> emit,
  ) async {
    emit(state.copyWith(status: AnchorWiseStatus.loading));

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock conversation history
      final welcomeMessage = ChatMessage(
        id: 'welcome',
        content: 'Hello! I\'m AnchorWise, your AI assistant for financial insights and market analysis. How can I help you today?',
        sender: MessageSender.ai,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        conversationId: _currentConversationId,
      );

      emit(state.copyWith(
        status: AnchorWiseStatus.idle,
        messages: [welcomeMessage],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnchorWiseStatus.error,
        error: 'Failed to load history: $e',
      ));
    }
  }

  /// Clear conversation
  void _onClearConversation(
    AnchorWiseClearConversation event,
    Emitter<AnchorWiseState> emit,
  ) {
    // Reset conversation ID to start a new conversation
    _currentConversationId = null;
    emit(const AnchorWiseState());
    // Reload welcome message
    add(const AnchorWiseLoadHistory());
  }

  /// Toggle typing indicator
  void _onToggleTyping(
    AnchorWiseToggleTyping event,
    Emitter<AnchorWiseState> emit,
  ) {
    emit(state.copyWith(isTyping: event.isTyping));
  }

  /// Cancel current request
  void _onCancelRequest(
    AnchorWiseCancelRequest event,
    Emitter<AnchorWiseState> emit,
  ) {
    emit(state.copyWith(
      status: AnchorWiseStatus.idle,
      isTyping: false,
      error: null,
    ));
  }

  /// Create new conversation
  void _onCreateNewConversation(
    AnchorWiseCreateNewConversation event,
    Emitter<AnchorWiseState> emit,
  ) async {
    emit(state.copyWith(status: AnchorWiseStatus.loading));

    try {
      // Create new conversation and get conversation ID
      final conversationId = await _createNewConversationUseCase.execute();
      
      // Store the new conversation ID
      _currentConversationId = conversationId;
      
      // Clear messages and reset to empty state with new conversation
      emit(state.copyWith(
        status: AnchorWiseStatus.idle,
        messages: const [],
        error: null,
        isTyping: false,
        currentConversationId: _currentConversationId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnchorWiseStatus.error,
        error: 'Failed to create new conversation: $e',
      ));
    }
  }

  /// Load conversations list
  void _onLoadConversations(
    AnchorWiseLoadConversations event,
    Emitter<AnchorWiseState> emit,
  ) async {
    emit(state.copyWith(isLoadingConversations: true));

    try {
      final response = await _getConversationsUseCase.execute();
      
      emit(state.copyWith(
        conversations: response.conversations,
        isLoadingConversations: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingConversations: false,
        error: 'Failed to load conversations: $e',
      ));
    }
  }

  /// Select a conversation from history
  void _onSelectConversation(
    AnchorWiseSelectConversation event,
    Emitter<AnchorWiseState> emit,
  ) async {
    emit(state.copyWith(status: AnchorWiseStatus.loading));

    try {
      final response = await _getConversationByIdUseCase.execute(event.conversationId);
      
      // Update current conversation ID
      _currentConversationId = event.conversationId;
      
      // Convert API messages to ChatMessage format
      final chatMessages = response.conversation.messages.map((msg) {
        return ChatMessage(
          id: msg.id,
          content: msg.content,
          sender: msg.role == 'user' ? MessageSender.user : MessageSender.ai,
          timestamp: DateTime.parse(msg.timestamp),
          conversationId: response.conversation.conversationId, // Use conversation ID from response
        );
      }).toList();
      
      emit(state.copyWith(
        status: AnchorWiseStatus.idle,
        messages: chatMessages,
        currentConversationId: event.conversationId,
        error: null,
        isTyping: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnchorWiseStatus.error,
        error: 'Failed to load conversation: $e',
      ));
    }
  }

  /// Delete a conversation
  void _onDeleteConversation(
    AnchorWiseDeleteConversation event,
    Emitter<AnchorWiseState> emit,
  ) async {
    try {
      // Delete the conversation
      await _deleteConversationUseCase.execute(event.conversationId);
      
      // Remove the deleted conversation from the current list
      final updatedConversations = state.conversations
          .where((conv) => conv.conversationId != event.conversationId)
          .toList();
      
      // If the deleted conversation was the current one, clear the messages
      bool shouldClearMessages = state.currentConversationId == event.conversationId;
      
      emit(state.copyWith(
        conversations: updatedConversations,
        messages: shouldClearMessages ? const [] : state.messages,
        currentConversationId: shouldClearMessages ? null : state.currentConversationId,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to delete conversation: $e',
      ));
    }
  }

  /// Send positive feedback for a message
  void _onSendPositiveFeedback(
    AnchorWiseSendPositiveFeedback event,
    Emitter<AnchorWiseState> emit,
  ) async {
    print('🔍 BLoC: Attempting to send positive feedback');
    print('🔍 Current conversation ID: $_currentConversationId');
    print('🔍 Message ID: ${event.messageId}');

    if (_currentConversationId == null || _currentConversationId!.isEmpty) {
      print('❌ BLoC: No active conversation ID');
      emit(state.copyWith(
        error: 'No active conversation to send feedback for',
      ));
      return;
    }

    try {
      final success = await _sendFeedbackUseCase.call(
        conversationId: _currentConversationId!,
        messageId: event.messageId,
        feedback: 'positive',
      );

      if (!success) {
        print('❌ BLoC: Feedback use case returned false');
        emit(state.copyWith(
          error: 'Failed to send positive feedback',
        ));
      } else {
        print('✅ BLoC: Positive feedback sent successfully');
      }
      // Note: We don't emit success state here as the UI handles feedback confirmation
    } catch (e) {
      print('❌ BLoC: Exception sending positive feedback: $e');
      emit(state.copyWith(
        error: 'Failed to send positive feedback: $e',
      ));
    }
  }

  /// Send negative feedback for a message
  void _onSendNegativeFeedback(
    AnchorWiseSendNegativeFeedback event,
    Emitter<AnchorWiseState> emit,
  ) async {
    print('🔍 BLoC: Attempting to send negative feedback');
    print('🔍 Current conversation ID: $_currentConversationId');
    print('🔍 Message ID: ${event.messageId}');

    if (_currentConversationId == null || _currentConversationId!.isEmpty) {
      print('❌ BLoC: No active conversation ID');
      emit(state.copyWith(
        error: 'No active conversation to send feedback for',
      ));
      return;
    }

    try {
      final success = await _sendFeedbackUseCase.call(
        conversationId: _currentConversationId!,
        messageId: event.messageId,
        feedback: 'negative',
      );

      if (!success) {
        print('❌ BLoC: Feedback use case returned false');
        emit(state.copyWith(
          error: 'Failed to send negative feedback',
        ));
      } else {
        print('✅ BLoC: Negative feedback sent successfully');
      }
      // Note: We don't emit success state here as the UI handles feedback confirmation
    } catch (e) {
      print('❌ BLoC: Exception sending negative feedback: $e');
      emit(state.copyWith(
        error: 'Failed to send negative feedback: $e',
      ));
    }
  }

}