import 'package:equatable/equatable.dart';

/// Events for the ContactBloc
abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

/// Event to load contact information
class ContactLoadRequested extends ContactEvent {
  const ContactLoadRequested();
}

/// Event to refresh contact information
class ContactRefreshRequested extends ContactEvent {
  const ContactRefreshRequested();
}

/// Event when user types in the question field
class ContactQuestionChanged extends ContactEvent {
  const ContactQuestionChanged({required this.question});

  final String question;

  @override
  List<Object> get props => [question];
}

/// Event to submit the contact form
class ContactFormSubmitted extends ContactEvent {
  const ContactFormSubmitted();
}

/// Event to navigate to FAQ (replaces current screen in stack)
class ContactNavigateToFaq extends ContactEvent {
  const ContactNavigateToFaq();
}

/// Event to reset the status after showing notifications
class ContactStatusReset extends ContactEvent {
  const ContactStatusReset();
}