import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class ContactLoadRequested extends ContactEvent {
  const ContactLoadRequested();
}

class ContactRefreshRequested extends ContactEvent {
  const ContactRefreshRequested();
}

class ContactQuestionChanged extends ContactEvent {
  const ContactQuestionChanged({required this.question});

  final String question;

  @override
  List<Object> get props => [question];
}

class ContactFormSubmitted extends ContactEvent {
  const ContactFormSubmitted();
}

class ContactNavigateToFaq extends ContactEvent {
  const ContactNavigateToFaq();
}

class ContactStatusReset extends ContactEvent {
  const ContactStatusReset();
}

class ContactRateLimitCooldownTick extends ContactEvent {
  const ContactRateLimitCooldownTick();
}
