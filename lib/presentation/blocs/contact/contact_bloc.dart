import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'contact_event.dart';
import 'contact_state.dart';
import '../../../domain/usecases/contact/contact_support_usecase.dart';
import '../../../services/storage_service.dart';

@injectable
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactSupportUseCase _contactSupportUseCase;
  Timer? _cooldownTimer;

  ContactBloc(
    this._contactSupportUseCase,
  ) : super(const ContactState()) {
    on<ContactLoadRequested>(_onContactLoadRequested);
    on<ContactRefreshRequested>(_onContactRefreshRequested);
    on<ContactSubjectChanged>(_onContactSubjectChanged);
    on<ContactQuestionChanged>(_onContactQuestionChanged);
    on<ContactFormSubmitted>(_onContactFormSubmitted);
    on<ContactNavigateToFaq>(_onContactNavigateToFaq);
    on<ContactStatusReset>(_onContactStatusReset);
    on<ContactRateLimitCooldownTick>(_onContactRateLimitCooldownTick);
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
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
      emit(
        state.copyWith(
          status: ContactStatus.failure,
          errorMessage: 'Failed to load contact information: $error',
        ),
      );
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
      emit(
        state.copyWith(
          status: ContactStatus.failure,
          errorMessage: 'Failed to refresh contact information: $error',
        ),
      );
    }
  }

  void _onContactSubjectChanged(
    ContactSubjectChanged event,
    Emitter<ContactState> emit,
  ) {
    final isValid = event.subject.trim().isNotEmpty && state.question.trim().isNotEmpty;
    emit(state.copyWith(subject: event.subject, isFormValid: isValid));
  }

  void _onContactQuestionChanged(
    ContactQuestionChanged event,
    Emitter<ContactState> emit,
  ) {
    final isValid = event.question.trim().isNotEmpty && state.subject.trim().isNotEmpty;
    emit(state.copyWith(question: event.question, isFormValid: isValid));
  }

  Future<void> _onContactFormSubmitted(
    ContactFormSubmitted event,
    Emitter<ContactState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: ContactStatus.submitting));

    try {
      // Get user info from storage
      final userId = await StorageService.getUserId();
      final username = await StorageService.getUsername();
      final userEmail = await StorageService.getUserEmail();

      final result = await _contactSupportUseCase.execute(
        subject: state.subject,
        message: state.question,
        userEmail: userEmail,
        userId: userId,
        username: username,
      );

      if (result.success) {
        emit(
          state.copyWith(
            status: ContactStatus.submitted,
            subject: '',
            question: '',
            isFormValid: false,
            conversationId: result.conversationId,
          ),
        );
      } else {
        // Check if it's a rate limiting error with retry after seconds
        final errorMessage = result.error ?? 'Failed to submit your question';
        if (result.retryAfterSeconds != null && result.retryAfterSeconds! > 0) {
          // Start countdown timer with backend-provided seconds
          _startCooldownTimer(emit, result.retryAfterSeconds!);
          emit(
            state.copyWith(
              status: ContactStatus.rateLimited,
              errorMessage:
                  'Please wait ${_formatTimeRemaining(result.retryAfterSeconds!)} before sending another message.',
              rateLimitCooldown: result.retryAfterSeconds!,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ContactStatus.failure,
              errorMessage: errorMessage,
            ),
          );
        }
      }
    } catch (error) {
      emit(
        state.copyWith(status: ContactStatus.failure, errorMessage: '$error'),
      );
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
    _cooldownTimer?.cancel();
    emit(state.copyWith(status: ContactStatus.success, rateLimitCooldown: 0));
  }

  void _onContactRateLimitCooldownTick(
    ContactRateLimitCooldownTick event,
    Emitter<ContactState> emit,
  ) {
    if (state.rateLimitCooldown > 0) {
      final newCooldown = state.rateLimitCooldown - 1;
      if (newCooldown > 0) {
        emit(
          state.copyWith(
            rateLimitCooldown: newCooldown,
            errorMessage:
                'Please wait ${_formatTimeRemaining(newCooldown)} before sending another message.',
          ),
        );
      } else {
        _cooldownTimer?.cancel();
        emit(
          state.copyWith(
            status: ContactStatus.success,
            rateLimitCooldown: 0,
            errorMessage: '',
          ),
        );
      }
    }
  }

  void _startCooldownTimer(Emitter<ContactState> emit, int seconds) {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const ContactRateLimitCooldownTick());
    });
  }

  String _formatTimeRemaining(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).ceil();
      return '$minutes minute${minutes == 1 ? '' : 's'}';
    } else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).ceil();
      if (minutes == 0) {
        return '$hours hour${hours == 1 ? '' : 's'}';
      } else {
        return '$hours hour${hours == 1 ? '' : 's'} $minutes minute${minutes == 1 ? '' : 's'}';
      }
    }
  }
}
