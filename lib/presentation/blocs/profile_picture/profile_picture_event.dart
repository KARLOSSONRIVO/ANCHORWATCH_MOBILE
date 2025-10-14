import 'package:equatable/equatable.dart';
import 'dart:io';

/// Events for the ProfilePictureBloc
abstract class ProfilePictureEvent extends Equatable {
  const ProfilePictureEvent();

  @override
  List<Object?> get props => [];
}

/// Event to pick an image from gallery or camera
class ProfilePicturePickImageRequested extends ProfilePictureEvent {
  final bool fromCamera;

  const ProfilePicturePickImageRequested({
    this.fromCamera = false,
  });

  @override
  List<Object?> get props => [fromCamera];
}

/// Event to upload the selected image
class ProfilePictureUploadRequested extends ProfilePictureEvent {
  final File imageFile;

  const ProfilePictureUploadRequested({
    required this.imageFile,
  });

  @override
  List<Object?> get props => [imageFile];
}

/// Event to confirm the uploaded image
class ProfilePictureConfirmRequested extends ProfilePictureEvent {
  final String s3Key;

  const ProfilePictureConfirmRequested({
    required this.s3Key,
  });

  @override
  List<Object?> get props => [s3Key];
}

/// Event to remove the current profile picture
class ProfilePictureRemoveRequested extends ProfilePictureEvent {
  const ProfilePictureRemoveRequested();
}

/// Event to reset the profile picture state
class ProfilePictureResetRequested extends ProfilePictureEvent {
  const ProfilePictureResetRequested();
}
