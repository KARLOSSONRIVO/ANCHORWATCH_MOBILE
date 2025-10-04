import 'package:equatable/equatable.dart';

/// Status enum for contact state
enum ContactStatus { initial, loading, success, failure, submitting, submitted, navigatingToFaq }

/// State for ContactBloc
class ContactState extends Equatable {
  const ContactState({
    this.status = ContactStatus.initial,
    this.errorMessage = '',
    this.question = '',
    this.isFormValid = false,
  });

  final ContactStatus status;
  final String errorMessage;
  final String question;
  final bool isFormValid;

  ContactState copyWith({
    ContactStatus? status,
    String? errorMessage,
    String? question,
    bool? isFormValid,
  }) {
    return ContactState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      question: question ?? this.question,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, question, isFormValid];
}