import 'package:equatable/equatable.dart';
import 'dart:io';
abstract class ProfilePictureEvent extends Equatable {
  const ProfilePictureEvent();

  @override
  List<Object?> get props => [];
}
class ProfilePicturePickImageRequested extends ProfilePictureEvent {
  final bool fromCamera;

  const ProfilePicturePickImageRequested({
    this.fromCamera = false,
  });

  @override
  List<Object?> get props => [fromCamera];
}
class ProfilePictureUploadRequested extends ProfilePictureEvent {
  final File imageFile;

  const ProfilePictureUploadRequested({
    required this.imageFile,
  });

  @override
  List<Object?> get props => [imageFile];
}
class ProfilePictureConfirmRequested extends ProfilePictureEvent {
  final String s3Key;

  const ProfilePictureConfirmRequested({
    required this.s3Key,
  });

  @override
  List<Object?> get props => [s3Key];
}
class ProfilePictureRemoveRequested extends ProfilePictureEvent {
  const ProfilePictureRemoveRequested();
}
class ProfilePictureResetRequested extends ProfilePictureEvent {
  const ProfilePictureResetRequested();
}

