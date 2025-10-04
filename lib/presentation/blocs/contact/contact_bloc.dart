import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';

/// BLoC to manage contact screen state
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(const ContactState()) {
    on<ContactLoadRequested>(_onContactLoadRequested);
    on<ContactRefreshRequested>(_onContactRefreshRequested);
    on<ContactQuestionChanged>(_onContactQuestionChanged);
    on<ContactFormSubmitted>(_onContactFormSubmitted);
    on<ContactNavigateToFaq>(_onContactNavigateToFaq);
  }

  Future<void> _onContactLoadRequested(
    ContactLoadRequested event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(status: ContactStatus.loading));
    
    try {
      // Simulate loading contact information
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(state.copyWith(status: ContactStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: ContactStatus.failure,
        errorMessage: 'Failed to load contact information: $error',
      ));
    }
  }

  Future<void> _onContactRefreshRequested(
    ContactRefreshRequested event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(status: ContactStatus.loading));
    
    try {
      // Simulate refreshing contact information
      await Future.delayed(const Duration(milliseconds: 300));
      
      emit(state.copyWith(status: ContactStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: ContactStatus.failure,
        errorMessage: 'Failed to refresh contact information: $error',
      ));
    }
  }

  void _onContactQuestionChanged(
    ContactQuestionChanged event,
    Emitter<ContactState> emit,
  ) {
    final isValid = event.question.trim().isNotEmpty;
    emit(state.copyWith(
      question: event.question,
      isFormValid: isValid,
    ));
  }

  Future<void> _onContactFormSubmitted(
    ContactFormSubmitted event,
    Emitter<ContactState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: ContactStatus.submitting));
    
    try {
      // Simulate form submission
      await Future.delayed(const Duration(seconds: 2));
      
      emit(state.copyWith(
        status: ContactStatus.submitted,
        question: '', // Clear the form after successful submission
        isFormValid: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ContactStatus.failure,
        errorMessage: 'Failed to submit your question: $error',
      ));
    }
  }

  void _onContactNavigateToFaq(
    ContactNavigateToFaq event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(status: ContactStatus.navigatingToFaq));
  }
}