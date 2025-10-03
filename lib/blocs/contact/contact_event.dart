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