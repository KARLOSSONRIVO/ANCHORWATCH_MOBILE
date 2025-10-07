import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/anchorwise/send_chat_message_usecase.dart';
import '../../../domain/usecases/anchorwise/create_new_conversation_usecase.dart';
import '../../../domain/usecases/anchorwise/get_conversations_usecase.dart';
import '../../../domain/usecases/anchorwise/get_conversation_by_id_usecase.dart';
import 'anchorwise_event.dart';
import 'anchorwise_state.dart';

/// BLoC for managing AnchorWise chat functionality
@injectable
class AnchorWiseBloc extends Bloc<AnchorWiseEvent, AnchorWiseState> {
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final CreateNewConversationUseCase _createNewConversationUseCase;
  final GetConversationsUseCase _getConversationsUseCase;
  final GetConversationByIdUseCase _getConversationByIdUseCase;
  String? _currentConversationId;

  AnchorWiseBloc(
    this._sendChatMessageUseCase, 
    this._createNewConversationUseCase,
    this._getConversationsUseCase,
    this._getConversationByIdUseCase,
  ) : super(const AnchorWiseState()) {
    on<AnchorWiseSendMessage>(_onSendMessage);
    on<AnchorWiseLoadHistory>(_onLoadHistory);
    on<AnchorWiseClearConversation>(_onClearConversation);
    on<AnchorWiseToggleTyping>(_onToggleTyping);
    on<AnchorWiseCancelRequest>(_onCancelRequest);
    on<AnchorWiseCreateNewConversation>(_onCreateNewConversation);
    on<AnchorWiseLoadConversations>(_onLoadConversations);
    on<AnchorWiseSelectConversation>(_onSelectConversation);
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

      // Parse timestamp from API response
      DateTime responseTimestamp;
      try {
        responseTimestamp = DateTime.parse(response.timestamp);
      } catch (e) {
        responseTimestamp = DateTime.now();
      }
      
      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: response.response,
        sender: MessageSender.ai,
        timestamp: responseTimestamp,
      );

      final finalMessages = [...updatedMessages, aiMessage];
      
      emit(state.copyWith(
        status: AnchorWiseStatus.idle,
        messages: finalMessages,
        isTyping: false,
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

}