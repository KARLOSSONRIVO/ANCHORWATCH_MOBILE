import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/profile/request_change_email_usecase.dart';
import '../../../domain/usecases/profile/confirm_change_email_usecase.dart';
import '../../../domain/entities/change_email/request_change_email_result.dart';
import '../../../domain/entities/change_email/confirm_change_email_result.dart';

abstract class ChangeEmailEvent extends Equatable {
  const ChangeEmailEvent();

  @override
  List<Object> get props => [];
}

class RequestChangeEmailSubmitted extends ChangeEmailEvent {
  final String newEmail;

  const RequestChangeEmailSubmitted({required this.newEmail});

  @override
  List<Object> get props => [newEmail];
}

class ConfirmChangeEmailSubmitted extends ChangeEmailEvent {
  final String otp;
  final String newEmail;

  const ConfirmChangeEmailSubmitted({
    required this.otp,
    required this.newEmail,
  });

  @override
  List<Object> get props => [otp, newEmail];
}

class ChangeEmailReset extends ChangeEmailEvent {}

abstract class ChangeEmailState extends Equatable {
  const ChangeEmailState();

  @override
  List<Object> get props => [];
}

class ChangeEmailInitial extends ChangeEmailState {}

class ChangeEmailRequestLoading extends ChangeEmailState {}

class ChangeEmailRequestSuccess extends ChangeEmailState {
  final RequestChangeEmailResult result;
  final String newEmail;

  const ChangeEmailRequestSuccess(this.result, this.newEmail);

  @override
  List<Object> get props => [result, newEmail];
}

class ChangeEmailRequestFailure extends ChangeEmailState {
  final String error;

  const ChangeEmailRequestFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChangeEmailConfirmLoading extends ChangeEmailState {}

class ChangeEmailConfirmSuccess extends ChangeEmailState {
  final ConfirmChangeEmailResult result;

  const ChangeEmailConfirmSuccess(this.result);

  @override
  List<Object> get props => [result];
}

class ChangeEmailConfirmFailure extends ChangeEmailState {
  final String error;

  const ChangeEmailConfirmFailure(this.error);

  @override
  List<Object> get props => [error];
}

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
    on<ChangeEmailReset>(_onChangeEmailReset);
  }

  Future<void> _onRequestChangeEmailSubmitted(
    RequestChangeEmailSubmitted event,
    Emitter<ChangeEmailState> emit,
  ) async {
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

  void _onChangeEmailReset(
    ChangeEmailReset event,
    Emitter<ChangeEmailState> emit,
  ) {
    emit(ChangeEmailInitial());
  }
}
