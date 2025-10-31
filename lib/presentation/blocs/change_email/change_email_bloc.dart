import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/profile/request_change_email_usecase.dart';
import '../../../domain/usecases/profile/confirm_change_email_usecase.dart';
import 'change_email_event.dart';
import 'change_email_state.dart';

@injectable
class ChangeEmailBloc extends Bloc<ChangeEmailEvent, ChangeEmailState> {
  final RequestChangeEmailUseCase _requestChangeEmailUseCase;
  final ConfirmChangeEmailUseCase _confirmChangeEmailUseCase;

  ChangeEmailBloc(
    this._requestChangeEmailUseCase,
    this._confirmChangeEmailUseCase,
  ) : super(ChangeEmailInitial()) {
    on<RequestChangeEmailSubmitted>(_onRequestChangeEmailSubmitted);
    on<ConfirmChangeEmailSubmitted>(_onConfirmChangeEmailSubmitted);
    on<ChangeEmailValidationRequested>(_onChangeEmailValidationRequested);
    on<ChangeEmailReset>(_onChangeEmailReset);
  }

  Future<void> _onRequestChangeEmailSubmitted(
    RequestChangeEmailSubmitted event,
    Emitter<ChangeEmailState> emit,
  ) async {
    // Validate email before proceeding
    final validationResult = _validateEmail(event.newEmail);
    if (!validationResult['isValid']) {
      emit(
        ChangeEmailValidationState(
          newEmail: event.newEmail,
          isValid: false,
          validationError: validationResult['error'] as String?,
          hasInteractedWithEmail: true,
        ),
      );
      return;
    }

    emit(ChangeEmailRequestLoading());

    try {
      final result = await _requestChangeEmailUseCase.execute(
        newEmail: event.newEmail,
      );

      if (result.success) {
        emit(ChangeEmailRequestSuccess(result, event.newEmail));
      } else {
        emit(
          ChangeEmailRequestFailure(
            result.error ?? 'Request change email failed',
          ),
        );
      }
    } catch (e) {
      emit(ChangeEmailRequestFailure(e.toString()));
    }
  }

  Future<void> _onConfirmChangeEmailSubmitted(
    ConfirmChangeEmailSubmitted event,
    Emitter<ChangeEmailState> emit,
  ) async {
    emit(ChangeEmailConfirmLoading());

    try {
      final result = await _confirmChangeEmailUseCase.execute(
        otp: event.otp,
        newEmail: event.newEmail,
      );

      if (result.success) {
        emit(ChangeEmailConfirmSuccess(result));
      } else {
        emit(
          ChangeEmailConfirmFailure(
            result.error ?? 'Confirm change email failed',
          ),
        );
      }
    } catch (e) {
      emit(ChangeEmailConfirmFailure(e.toString()));
    }
  }

  void _onChangeEmailValidationRequested(
    ChangeEmailValidationRequested event,
    Emitter<ChangeEmailState> emit,
  ) {
    final validationResult = _validateEmail(event.newEmail);

    emit(
      ChangeEmailValidationState(
        newEmail: event.newEmail,
        isValid: validationResult['isValid'] as bool,
        validationError: validationResult['error'] as String?,
        hasInteractedWithEmail: event.hasInteractedWithEmail,
      ),
    );
  }

  Map<String, dynamic> _validateEmail(String email) {
    if (email.trim().isEmpty) {
      return <String, dynamic>{
        'isValid': false,
        'error': 'Please enter an email address',
      };
    }

    final trimmedEmail = email.trim();

    // Basic email validation regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return <String, dynamic>{
        'isValid': false,
        'error': 'Please enter a valid email address',
      };
    }

    return <String, dynamic>{'isValid': true, 'error': null};
  }

  void _onChangeEmailReset(
    ChangeEmailReset event,
    Emitter<ChangeEmailState> emit,
  ) {
    emit(ChangeEmailInitial());
  }
}
