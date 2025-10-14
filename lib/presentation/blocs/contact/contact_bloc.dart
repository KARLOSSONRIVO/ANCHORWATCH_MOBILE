import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'contact_event.dart';
import 'contact_state.dart';
import '../../../domain/usecases/contact/contact_support_usecase.dart';

/// BLoC to manage contact screen state
@injectable
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactSupportUseCase _contactSupportUseCase;

  ContactBloc(this._contactSupportUseCase) : super(const ContactState()) {
    print('[CONTACT_BLOC] ContactBloc created');
    on<ContactLoadRequested>(_onContactLoadRequested);
    on<ContactRefreshRequested>(_onContactRefreshRequested);
    on<ContactQuestionChanged>(_onContactQuestionChanged);
    on<ContactFormSubmitted>(_onContactFormSubmitted);
    on<ContactNavigateToFaq>(_onContactNavigateToFaq);
    on<ContactStatusReset>(_onContactStatusReset);
  }

  Future<void> _onContactLoadRequested(
    ContactLoadRequested event,
    Emitter<ContactState> emit,
  ) async {
    print('[CONTACT_BLOC] Load requested, emitting loading state');
    emit(state.copyWith(status: ContactStatus.loading));
    
    try {
      // Simulate loading contact information
      await Future.delayed(const Duration(milliseconds: 500));
      
      print('[CONTACT_BLOC] Load completed, emitting success state');
      emit(state.copyWith(status: ContactStatus.success));
    } catch (error) {
      print('[CONTACT_BLOC] Load failed: $error');
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
      print('[CONTACT_BLOC] Submitting contact form with message: ${state.question}');
      
      // Use the real API to submit the contact form
      final result = await _contactSupportUseCase.execute(
        message: state.question,
      );
      
      print('[CONTACT_BLOC] Contact form submitted successfully: ${result.message}');
      
      emit(state.copyWith(
        status: ContactStatus.submitted,
        question: '', // Clear the form after successful submission
        isFormValid: false,
      ));
    } catch (error) {
      print('[CONTACT_BLOC] Contact form submission failed: $error');
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

  void _onContactStatusReset(
    ContactStatusReset event,
    Emitter<ContactState> emit,
  ) {
    print('[CONTACT_BLOC] Status reset to success');
    emit(state.copyWith(status: ContactStatus.success));
  }

  @override
  Future<void> close() {
    print('[CONTACT_BLOC] ContactBloc disposed');
    return super.close();
  }
}