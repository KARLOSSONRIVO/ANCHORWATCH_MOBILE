import 'package:flutter_bloc/flutter_bloc.dart';
import 'faq_event.dart';
import 'faq_state.dart';

/// BLoC to manage FAQ screen state
class FaqBloc extends Bloc<FaqEvent, FaqState> {
  FaqBloc() : super(const FaqState()) {
    on<FaqLoadRequested>(_onFaqLoadRequested);
    on<FaqRefreshRequested>(_onFaqRefreshRequested);
  }

  Future<void> _onFaqLoadRequested(
    FaqLoadRequested event,
    Emitter<FaqState> emit,
  ) async {
    emit(state.copyWith(status: FaqStatus.loading));
    
    try {
      // Simulate loading FAQ information
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(state.copyWith(status: FaqStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: FaqStatus.failure,
        errorMessage: 'Failed to load FAQ information: $error',
      ));
    }
  }

  Future<void> _onFaqRefreshRequested(
    FaqRefreshRequested event,
    Emitter<FaqState> emit,
  ) async {
    emit(state.copyWith(status: FaqStatus.loading));
    
    try {
      // Simulate refreshing FAQ information
      await Future.delayed(const Duration(milliseconds: 300));
      
      emit(state.copyWith(status: FaqStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: FaqStatus.failure,
        errorMessage: 'Failed to refresh FAQ information: $error',
      ));
    }
  }
}