import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'contact_event.dart';
import 'contact_state.dart';
import '../../../domain/usecases/contact/contact_support_usecase.dart';
@injectable
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactSupportUseCase _contactSupportUseCase;

  ContactBloc(this._contactSupportUseCase) : super(const ContactState()) {
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
    emit(state.copyWith(status: ContactStatus.loading));
    
    try {
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
      await _contactSupportUseCase.execute(
        message: state.question,
      );
      
      emit(state.copyWith(
        status: ContactStatus.submitted,
        question: '',
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

  void _onContactStatusReset(
    ContactStatusReset event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(status: ContactStatus.success));
  }

}

