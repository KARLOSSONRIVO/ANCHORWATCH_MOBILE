import 'package:equatable/equatable.dart';

abstract class ChangeUsernameState extends Equatable {
  const ChangeUsernameState();

  @override
  List<Object> get props => [];
}

class ChangeUsernameInitial extends ChangeUsernameState {}

class ChangeUsernameLoading extends ChangeUsernameState {}

class ChangeUsernameSuccess extends ChangeUsernameState {
  final String message;
  final String newUsername;

  const ChangeUsernameSuccess({
    required this.message,
    required this.newUsername,
  });

  @override
  List<Object> get props => [message, newUsername];
}

class ChangeUsernameFailure extends ChangeUsernameState {
  final String error;

  const ChangeUsernameFailure({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}