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
  void _onSendMessage(
    AnchorWiseSendMessage event,
    Emitter<AnchorWiseState> emit,
  ) async {
    if (event.message.trim().isEmpty) return;
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
    emit(state.copyWith(isTyping: true));

    try {
      final response = await _sendChatMessageUseCase.execute(
        query: event.message,
        conversationId: _currentConversationId,
      );
      if (response.conversationId != null && response.conversationId!.isNotEmpty) {
        _currentConversationId = response.conversationId!;
      }
      if (_currentConversationId != null) {
        try {
          final conversationResponse = await _getConversationByIdUseCase.execute(_currentConversationId!);
          final chatMessages = conversationResponse.conversation.messages.map((msg) {
            return ChatMessage(
              id: msg.id, // Use the actual backend message ID
              content: msg.content,
              sender: msg.role == 'user' ? MessageSender.user : MessageSender.ai,
              timestamp: DateTime.parse(msg.timestamp),
              conversationId: conversationResponse.conversation.conversationId,
            );
          }).toList();
          
        emit(state.copyWith(
          status: AnchorWiseStatus.idle,
          messages: chatMessages,
          isTyping: false,
          currentConversationId: _currentConversationId,
        ));
        return;
      } catch (_) {}
    }
    DateTime responseTimestamp;
    try {
      responseTimestamp = DateTime.parse(response.timestamp);
    } catch (_) {
      responseTimestamp = DateTime.now();
    }
    final aiMessageId = response.messageId ?? (DateTime.now().millisecondsSinceEpoch + 1).toString();      final aiMessage = ChatMessage(
        id: aiMessageId,
        content: response.response,
        sender: MessageSender.ai,
        timestamp: responseTimestamp,
        conversationId: _currentConversationId,
      );
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
  void _onLoadHistory(
    AnchorWiseLoadHistory event,
    Emitter<AnchorWiseState> emit,
  ) async {
    emit(state.copyWith(status: AnchorWiseStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 1));
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
  void _onClearConversation(
    AnchorWiseClearConversation event,
    Emitter<AnchorWiseState> emit,
  ) {
    _currentConversationId = null;
    emit(const AnchorWiseState());
    add(const AnchorWiseLoadHistory());
  }
  void _onToggleTyping(
    AnchorWiseToggleTyping event,
    Emitter<AnchorWiseState> emit,
  ) {
    emit(state.copyWith(isTyping: event.isTyping));
  }
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
  void _onCreateNewConversation(
    AnchorWiseCreateNewConversation event,
    Emitter<AnchorWiseState> emit,
  ) async {
    emit(state.copyWith(status: AnchorWiseStatus.loading));

    try {
      final conversationId = await _createNewConversationUseCase.execute();
      _currentConversationId = conversationId;
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
  void _onSelectConversation(
    AnchorWiseSelectConversation event,
    Emitter<AnchorWiseState> emit,
  ) async {
    emit(state.copyWith(status: AnchorWiseStatus.loading));

    try {
      final response = await _getConversationByIdUseCase.execute(event.conversationId);
      _currentConversationId = event.conversationId;
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
  void _onDeleteConversation(
    AnchorWiseDeleteConversation event,
    Emitter<AnchorWiseState> emit,
  ) async {
    try {
      await _deleteConversationUseCase.execute(event.conversationId);
      final updatedConversations = state.conversations
          .where((conv) => conv.conversationId != event.conversationId)
          .toList();
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
  void _onSendPositiveFeedback(
    AnchorWiseSendPositiveFeedback event,
    Emitter<AnchorWiseState> emit,
  ) async {


    if (_currentConversationId == null || _currentConversationId!.isEmpty) {
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
        emit(state.copyWith(
          error: 'Failed to send positive feedback',
        ));
      } else {
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to send positive feedback: $e',
      ));
    }
  }
  void _onSendNegativeFeedback(
    AnchorWiseSendNegativeFeedback event,
    Emitter<AnchorWiseState> emit,
  ) async {


    if (_currentConversationId == null || _currentConversationId!.isEmpty) {
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
        emit(state.copyWith(
          error: 'Failed to send negative feedback',
        ));
      } else {
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to send negative feedback: $e',
      ));
    }
  }

}

