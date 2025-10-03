import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';

/// BLoC to manage contact screen state
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(const ContactState()) {
    on<ContactLoadRequested>(_onContactLoadRequested);
    on<ContactRefreshRequested>(_onContactRefreshRequested);
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
}