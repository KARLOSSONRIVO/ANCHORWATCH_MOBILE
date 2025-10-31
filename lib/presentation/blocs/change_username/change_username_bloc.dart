import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/profile/change_username_usecase.dart';
import 'change_username_event.dart';
import 'change_username_state.dart';

// Export events and states for proper BLoC architecture
export 'change_username_event.dart';
export 'change_username_state.dart';

@injectable
class ChangeUsernameBloc
    extends Bloc<ChangeUsernameEvent, ChangeUsernameState> {
  final ChangeUsernameUseCase _changeUsernameUseCase;

  ChangeUsernameBloc(this._changeUsernameUseCase)
    : super(ChangeUsernameInitial()) {
    on<ChangeUsernameSubmitted>(_onChangeUsernameSubmitted);
    on<ChangeUsernameValidationRequested>(_onChangeUsernameValidationRequested);
  }

  Future<void> _onChangeUsernameSubmitted(
    ChangeUsernameSubmitted event,
    Emitter<ChangeUsernameState> emit,
  ) async {
    // Validate before submitting
    final validationResult = _validateUsername(event.newUsername);
    if (!validationResult['isValid']) {
      emit(
        ChangeUsernameValidationState(
          newUsername: event.newUsername,
          isValid: false,
          validationError: validationResult['error'],
        ),
      );
      return;
    }

    emit(ChangeUsernameLoading());

    try {
      final result = await _changeUsernameUseCase.execute(
        newUsername: event.newUsername,
      );

      if (result.success) {
        emit(
          ChangeUsernameSuccess(
            message: result.message,
            newUsername: event.newUsername,
          ),
        );
      } else {
        emit(
          ChangeUsernameFailure(
            error: result.error ?? 'Change username failed',
          ),
        );
      }
    } catch (e) {
      emit(ChangeUsernameFailure(error: e.toString()));
    }
  }

  void _onChangeUsernameValidationRequested(
    ChangeUsernameValidationRequested event,
    Emitter<ChangeUsernameState> emit,
  ) {
    final validationResult = _validateUsername(event.newUsername);
    emit(
      ChangeUsernameValidationState(
        newUsername: event.newUsername,
        isValid: validationResult['isValid'],
        validationError: validationResult['error'],
      ),
    );
  }

  Map<String, dynamic> _validateUsername(String username) {
    if (username.trim().isEmpty) {
      return {'isValid': false, 'error': 'Please enter a username'};
    }

    final trimmedUsername = username.trim();

    if (trimmedUsername.length < 3) {
      return {
        'isValid': false,
        'error': 'Username must be at least 3 characters long',
      };
    }

    if (trimmedUsername.length > 30) {
      return {
        'isValid': false,
        'error': 'Username cannot exceed 30 characters',
      };
    }

    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(trimmedUsername)) {
      return {
        'isValid': false,
        'error': 'Username can only contain letters, numbers, and underscores',
      };
    }

    return {'isValid': true, 'error': null};
  }
}
