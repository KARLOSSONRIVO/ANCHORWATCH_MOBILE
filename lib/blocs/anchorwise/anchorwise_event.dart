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