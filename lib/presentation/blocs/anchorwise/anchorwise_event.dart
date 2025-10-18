import 'package:equatable/equatable.dart';
abstract class AnchorWiseEvent extends Equatable {
  const AnchorWiseEvent();

  @override
  List<Object> get props => [];
}
class AnchorWiseSendMessage extends AnchorWiseEvent {
  final String message;

  const AnchorWiseSendMessage(this.message);

  @override
  List<Object> get props => [message];
}
class AnchorWiseLoadHistory extends AnchorWiseEvent {
  const AnchorWiseLoadHistory();
}
class AnchorWiseClearConversation extends AnchorWiseEvent {
  const AnchorWiseClearConversation();
}
class AnchorWiseToggleTyping extends AnchorWiseEvent {
  final bool isTyping;

  const AnchorWiseToggleTyping(this.isTyping);

  @override
  List<Object> get props => [isTyping];
}
class AnchorWiseCancelRequest extends AnchorWiseEvent {
  const AnchorWiseCancelRequest();
}
class AnchorWiseCreateNewConversation extends AnchorWiseEvent {
  const AnchorWiseCreateNewConversation();
}
class AnchorWiseLoadConversations extends AnchorWiseEvent {
  const AnchorWiseLoadConversations();
}
class AnchorWiseSelectConversation extends AnchorWiseEvent {
  final String conversationId;

  const AnchorWiseSelectConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}
class AnchorWiseDeleteConversation extends AnchorWiseEvent {
  final String conversationId;

  const AnchorWiseDeleteConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}
class AnchorWiseSendPositiveFeedback extends AnchorWiseEvent {
  final String messageId;

  const AnchorWiseSendPositiveFeedback(this.messageId);

  @override
  List<Object> get props => [messageId];
}
class AnchorWiseSendNegativeFeedback extends AnchorWiseEvent {
  final String messageId;

  const AnchorWiseSendNegativeFeedback(this.messageId);

  @override
  List<Object> get props => [messageId];
}
