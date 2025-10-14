import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/profile/change_username_usecase.dart';
import 'change_username_event.dart';
import 'change_username_state.dart';

@injectable
class ChangeUsernameBloc extends Bloc<ChangeUsernameEvent, ChangeUsernameState> {
  final ChangeUsernameUseCase _changeUsernameUseCase;

  ChangeUsernameBloc(this._changeUsernameUseCase) : super(ChangeUsernameInitial()) {
    on<ChangeUsernameSubmitted>(_onChangeUsernameSubmitted);
  }

  Future<void> _onChangeUsernameSubmitted(
    ChangeUsernameSubmitted event,
    Emitter<ChangeUsernameState> emit,
  ) async {
    emit(ChangeUsernameLoading());

    try {
      final result = await _changeUsernameUseCase.execute(
        newUsername: event.newUsername,
      );

      if (result.success) {
        emit(ChangeUsernameSuccess(
          message: result.message, 
          newUsername: event.newUsername,
        ));
      } else {
        emit(ChangeUsernameFailure(error: result.error ?? 'Change username failed'));
      }
    } catch (e) {
      emit(ChangeUsernameFailure(error: e.toString()));
    }
  }
}