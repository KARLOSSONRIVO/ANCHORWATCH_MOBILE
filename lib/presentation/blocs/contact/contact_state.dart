import 'package:equatable/equatable.dart';

enum ContactStatus {
  initial,
  loading,
  success,
  failure,
  submitting,
  submitted,
  navigatingToFaq,
  rateLimited,
}

class ContactState extends Equatable {
  const ContactState({
    this.status = ContactStatus.initial,
    this.errorMessage = '',
    this.subject = '',
    this.question = '',
    this.isFormValid = false,
    this.rateLimitCooldown = 0,
    this.conversationId,
  });

  final ContactStatus status;
  final String errorMessage;
  final String subject;
  final String question;
  final bool isFormValid;
  final int rateLimitCooldown; // in seconds
  final String? conversationId;

  ContactState copyWith({
    ContactStatus? status,
    String? errorMessage,
    String? subject,
    String? question,
    bool? isFormValid,
    int? rateLimitCooldown,
    String? conversationId,
  }) {
    return ContactState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      subject: subject ?? this.subject,
      question: question ?? this.question,
      isFormValid: isFormValid ?? this.isFormValid,
      rateLimitCooldown: rateLimitCooldown ?? this.rateLimitCooldown,
      conversationId: conversationId ?? this.conversationId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    subject,
    question,
    isFormValid,
    rateLimitCooldown,
    conversationId,
  ];
}
