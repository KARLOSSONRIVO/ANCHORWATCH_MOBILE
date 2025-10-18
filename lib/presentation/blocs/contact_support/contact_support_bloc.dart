import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/contact/contact_support_usecase.dart';
import '../../../domain/entities/contact/contact_support_result.dart';
abstract class ContactSupportEvent extends Equatable {
  const ContactSupportEvent();

  @override
  List<Object> get props => [];
}

class ContactSupportSubmitted extends ContactSupportEvent {
  final String message;

  const ContactSupportSubmitted({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
abstract class ContactSupportState extends Equatable {
  const ContactSupportState();

  @override
  List<Object> get props => [];
}

class ContactSupportInitial extends ContactSupportState {}

class ContactSupportLoading extends ContactSupportState {}

class ContactSupportSuccess extends ContactSupportState {
  final ContactSupportResult result;

  const ContactSupportSuccess(this.result);

  @override
  List<Object> get props => [result];
}

class ContactSupportFailure extends ContactSupportState {
  final String error;

  const ContactSupportFailure(this.error);

  @override
  List<Object> get props => [error];
}
@injectable
class ContactSupportBloc extends Bloc<ContactSupportEvent, ContactSupportState> {
  final ContactSupportUseCase _contactSupportUseCase;

  ContactSupportBloc(this._contactSupportUseCase) : super(ContactSupportInitial()) {
    on<ContactSupportSubmitted>(_onContactSupportSubmitted);
  }

  Future<void> _onContactSupportSubmitted(
    ContactSupportSubmitted event,
    Emitter<ContactSupportState> emit,
  ) async {
    emit(ContactSupportLoading());

    try {
      final result = await _contactSupportUseCase.execute(
        message: event.message,
      );
      emit(ContactSupportSuccess(result));
    } catch (e) {
      emit(ContactSupportFailure(e.toString()));
    }
  }
}

