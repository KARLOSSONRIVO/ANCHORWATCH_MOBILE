import 'package:equatable/equatable.dart';

/// Events for the AnchorWiseBloc
abstract class AnchorWiseEvent extends Equatable {
  const AnchorWiseEvent();

  @override
  List<Object> get props => [];
}

/// Event to send a message
class AnchorWiseSendMessage extends AnchorWiseEvent {
  final String message;

  const AnchorWiseSendMessage(this.message);

  @override
  List<Object> get props => [message];
}

/// Event to load conversation history
class AnchorWiseLoadHistory extends AnchorWiseEvent {
  const AnchorWiseLoadHistory();
}

/// Event to clear conversation
class AnchorWiseClearConversation extends AnchorWiseEvent {
  const AnchorWiseClearConversation();
}

/// Event to toggle typing indicator
class AnchorWiseToggleTyping extends AnchorWiseEvent {
  final bool isTyping;

  const AnchorWiseToggleTyping(this.isTyping);

  @override
  List<Object> get props => [isTyping];
}

/// Event to cancel current request
class AnchorWiseCancelRequest extends AnchorWiseEvent {
  const AnchorWiseCancelRequest();
}

/// Event to create a new conversation
class AnchorWiseCreateNewConversation extends AnchorWiseEvent {
  const AnchorWiseCreateNewConversation();
}

/// Event to load conversations list
class AnchorWiseLoadConversations extends AnchorWiseEvent {
  const AnchorWiseLoadConversations();
}

/// Event to select a conversation from history
class AnchorWiseSelectConversation extends AnchorWiseEvent {
  final String conversationId;

  const AnchorWiseSelectConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}