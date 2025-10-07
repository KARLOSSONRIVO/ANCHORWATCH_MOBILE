import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/anchorwise/send_chat_message_usecase.dart';
import '../../../domain/usecases/anchorwise/create_new_conversation_usecase.dart';
import 'anchorwise_event.dart';
import 'anchorwise_state.dart';

/// BLoC for managing AnchorWise chat functionality
@injectable
class AnchorWiseBloc extends Bloc<AnchorWiseEvent, AnchorWiseState> {
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final CreateNewConversationUseCase _createNewConversationUseCase;
  String? _currentConversationId;

  AnchorWiseBloc(
    this._sendChatMessageUseCase, 
    this._createNewConversationUseCase,
  ) : super(const AnchorWiseState()) {
    on<AnchorWiseSendMessage>(_onSendMessage);
    on<AnchorWiseLoadHistory>(_onLoadHistory);
    on<AnchorWiseClearConversation>(_onClearConversation);
    on<AnchorWiseToggleTyping>(_onToggleTyping);
    on<AnchorWiseCancelRequest>(_onCancelRequest);
    on<AnchorWiseCreateNewConversation>(_onCreateNewConversation);
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
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnchorWiseStatus.error,
        error: 'Failed to create new conversation: $e',
      ));
    }
  }

}