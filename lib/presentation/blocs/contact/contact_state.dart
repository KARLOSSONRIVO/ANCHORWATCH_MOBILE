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
    this.question = '',
    this.isFormValid = false,
    this.rateLimitCooldown = 0,
  });

  final ContactStatus status;
  final String errorMessage;
  final String question;
  final bool isFormValid;
  final int rateLimitCooldown; // in seconds

  ContactState copyWith({
    ContactStatus? status,
    String? errorMessage,
    String? question,
    bool? isFormValid,
    int? rateLimitCooldown,
  }) {
    return ContactState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      question: question ?? this.question,
      isFormValid: isFormValid ?? this.isFormValid,
      rateLimitCooldown: rateLimitCooldown ?? this.rateLimitCooldown,
    );
  }

  @override
  List<Object> get props => [
    status,
    errorMessage,
    question,
    isFormValid,
    rateLimitCooldown,
  ];
}
