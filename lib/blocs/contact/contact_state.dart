import 'package:equatable/equatable.dart';

/// Status enum for contact state
enum ContactStatus { initial, loading, success, failure }

/// State for ContactBloc
class ContactState extends Equatable {
  const ContactState({
    this.status = ContactStatus.initial,
    this.errorMessage = '',
  });

  final ContactStatus status;
  final String errorMessage;

  ContactState copyWith({
    ContactStatus? status,
    String? errorMessage,
  }) {
    return ContactState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, errorMessage];
}