import 'package:equatable/equatable.dart';

abstract class ChangeUsernameEvent extends Equatable {
  const ChangeUsernameEvent();

  @override
  List<Object> get props => [];
}

class ChangeUsernameSubmitted extends ChangeUsernameEvent {
  final String newUsername;

  const ChangeUsernameSubmitted({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
}

class ChangeUsernameValidationRequested extends ChangeUsernameEvent {
  final String newUsername;

  const ChangeUsernameValidationRequested({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
}
